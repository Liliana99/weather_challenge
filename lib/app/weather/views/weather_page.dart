import 'dart:async';
// ignore: unused_import
import 'dart:ui' as ui show Image;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spritewidget/spritewidget.dart';
import 'package:weather_challenge/app/search/search.dart';
import 'package:weather_challenge/app/settings/settings.dart';
import 'package:weather_challenge/app/weather/utils/weather_conditions_world.dart';
import 'package:weather_challenge/app/weather/widgets/widgets_weather.dart';
import 'package:weather_challenge/app/weather/repositories/repository.dart';
import 'package:weather_challenge/app/weather/blocs/bloc.dart';

// The sprite sheet contains an image and a set of rectangles defining the
// individual sprites.
SpriteSheet sprites;

// The image map hold all of our image assets.
ImageMap _images;
enum WeatherType { sun, rain, snow, shower }

class WeatherPage extends StatelessWidget {
  final WeatherRepository weatherRepository;

  // ignore: sort_constructors_first
  const WeatherPage({Key key, this.weatherRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherBloc(weatherRepository: weatherRepository),
      child: WeatherBody(
        weatherRepository: weatherRepository,
      ),
    );
  }
}

class WeatherBody extends StatefulWidget {
  final WeatherRepository weatherRepository;

  // ignore: sort_constructors_first
  WeatherBody({Key key, @required this.weatherRepository})
      : assert(weatherRepository != null),
        super(key: key);

  @override
  State<WeatherBody> createState() => _WeatherBodyState();
}

class _WeatherBodyState extends State<WeatherBody> {
  WeatherBloc _weatherBloc;
  Completer<void> _refreshCompleter;
  bool assetsLoaded = false;

  // The weather world is our sprite tree that handles the weather
  // animations.
  WeatherWorld weatherWorld;

  // This method loads all assets that are needed for the demo.
  Future<Null> _loadAssets(AssetBundle bundle) async {
    // Load images using an ImageMap
    _images = ImageMap(bundle);
    await _images.load(<String>[
      'assets/weather/clouds-0.png',
      'assets/weather/clouds-1.png',
      'assets/weather/ray.png',
      'assets/weather/sun.png',
      'assets/weather/weathersprites.png',
      'assets/weather/icon-sun.png',
      'assets/weather/icon-rain.png',
      'assets/weather/icon-snow.png'
    ]);

    // Load the sprite sheet, which contains snowflakes and rain drops.
    final json = await DefaultAssetBundle.of(context)
        .loadString('assets/weather/weathersprites.json');
    sprites = SpriteSheet(_images['assets/weather/weathersprites.png'], json);
  }

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _weatherBloc = WeatherBloc(weatherRepository: widget.weatherRepository);
    // Get our root asset bundle
    final bundle = rootBundle;

    // Load all graphics, then set the state to assetsLoaded and create the
    // WeatherWorld sprite tree
    _loadAssets(
      bundle,
    ).then((_) {
      setState(() {
        assetsLoaded = true;
        weatherWorld = WeatherWorld();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Until assets are loaded we are just displaying a blue screen.
    // If we were to load many more images, we might want to do some
    // loading animation here.

    if (!assetsLoaded) {
      return Scaffold(
        body: Container(
          // ignore: prefer_const_constructors
          decoration: BoxDecoration(
            color: const Color(0xff4aaafb),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Weather'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                SettingsPage.route(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final city = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CitySelection(),
                ),
              );
              if (city != null) {
                _weatherBloc.add(FetchWeather(city: city as String));
              }
            },
          )
        ],
      ),
      body: Material(
        child: Stack(
          children: <Widget>[
            SpriteWidget(weatherWorld),
            Center(
              child: BlocBuilder<WeatherBloc, WeatherBlocState>(
                cubit: _weatherBloc,
                builder: (_, WeatherBlocState state) {
                  if (state is WeatherEmpty) {
                    return WeatherSelect();
                  }
                  if (state is WeatherLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is WeatherLoaded) {
                    final weather = state.weather;
                    _refreshCompleter?.complete();
                    _refreshCompleter = Completer();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        weatherWorld.weatherType = WeatherConditionsWorld()
                            .actWeatherWorld(condition: weather.condition);
                      });
                    });
                    return RefreshIndicator(
                      onRefresh: () {
                        _weatherBloc.add(
                          RefreshWeather(city: weather.location),
                        );
                        return _refreshCompleter.future;
                      },
                      child: LocationAndTemperature(
                          weather: weather, weatherWorld: weatherWorld),
                    );
                  }
                  if (state is WeatherError) {
                    return WeatherErrorResponse();
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _weatherBloc.close();
    super.dispose();
  }
}

// For the different weathers we are displaying different gradient backgrounds,
// these are the colors for top and bottom.
const List<Color> _kBackgroundColorsTop = <Color>[
  Color(0xff5ebbd5),
  Color(0xff0b2734),
  Color(0xffcbced7)
];

const List<Color> _kBackgroundColorsBottom = <Color>[
  Color(0xff4aaafb),
  Color(0xff4c5471),
  Color(0xffe0e3ec)
];

// The WeatherWorld is our root node for our sprite tree. The size of the tree
// will be scaled to fit into our SpriteWidget container.
class WeatherWorld extends NodeWithSize {
  WeatherWorld() : super(const Size(2048.0, 2048.0)) {
    // Start by adding a background.
    _background = GradientNode(
      // ignore: unnecessary_this
      this.size,
      _kBackgroundColorsTop[0],
      _kBackgroundColorsBottom[0],
    );
    addChild(_background);

    // Then three layers of clouds, that will be scrolled in parallax.
    _cloudsSharp = CloudLayer(
        image: _images['assets/weather/clouds-0.png'],
        rotated: false,
        dark: false,
        loopTime: 20.0);
    addChild(_cloudsSharp);

    _cloudsDark = CloudLayer(
        image: _images['assets/weather/clouds-1.png'],
        rotated: true,
        dark: true,
        loopTime: 40.0);
    addChild(_cloudsDark);

    _cloudsSoft = CloudLayer(
        image: _images['assets/weather/clouds-1.png'],
        rotated: false,
        dark: false,
        loopTime: 60.0);
    addChild(_cloudsSoft);

    // Add the sun, rain, and snow (which we are going to fade in/out depending
    // on which weather are selected.
    _sun = Sun();
    // ignore: cascade_invocations
    _sun.position = const Offset(1024.0, 1024.0);
    // ignore: cascade_invocations
    _sun.scale = 1.5;
    addChild(_sun);

    _rain = Rain();
    addChild(_rain);

    _snow = Snow();
    addChild(_snow);
  }

  GradientNode _background;
  CloudLayer _cloudsSharp;
  CloudLayer _cloudsSoft;
  CloudLayer _cloudsDark;
  Sun _sun;
  Rain _rain;
  Snow _snow;

  WeatherType get weatherType => _weatherType;

  WeatherType _weatherType = WeatherType.sun;

  set weatherType(WeatherType weatherType) {
    if (weatherType == _weatherType) return;

    // Handle changes between weather types.
    _weatherType = weatherType;

    // Fade the background
    _background.motions.stopAll();

    // Fade the background from one gradient to another.
    _background.motions.run(MotionTween<Color>(
        (a) => _background.colorTop = a as Color,
        _background.colorTop,
        _kBackgroundColorsTop[weatherType.index],
        1.0));

    _background.motions.run(MotionTween<Color>(
        (a) => _background.colorBottom = a as Color,
        _background.colorBottom,
        _kBackgroundColorsBottom[weatherType.index],
        1.0));

    // Activate/deactivate sun, rain, snow, and dark clouds.
    _cloudsDark.active = weatherType != WeatherType.sun;
    _sun.active = weatherType == WeatherType.sun;
    _rain.active = weatherType == WeatherType.rain;
    _snow.active = weatherType == WeatherType.snow;
  }

  @override
  void spriteBoxPerformedLayout() {
    // If the device is rotated or if the size of the SpriteWidget changes we
    // are adjusting the position of the sun.
    _sun.position = spriteBox.visibleArea.topLeft + const Offset(350.0, 180.0);
  }
}

// The GradientNode performs custom drawing to draw a gradient background.
class GradientNode extends NodeWithSize {
  GradientNode(Size size, this.colorTop, this.colorBottom) : super(size);

  Color colorTop;
  Color colorBottom;

  @override
  void paint(Canvas canvas) {
    applyTransformForPivot(canvas);

    // ignore: prefer_final_locals
    var rect = Offset.zero & size;
    // ignore: omit_local_variable_types
    Paint gradientPaint = new Paint()
      // ignore: unnecessary_new
      ..shader = new LinearGradient(
          begin: FractionalOffset.topLeft,
          end: FractionalOffset.bottomLeft,
          colors: <Color>[colorTop, colorBottom],
          stops: <double>[0.0, 1.0]).createShader(rect);

    canvas.drawRect(rect, gradientPaint);
  }
}

// Draws and animates a cloud layer using two sprites.
class CloudLayer extends Node {
  CloudLayer({ui.Image image, bool dark, bool rotated, double loopTime}) {
    // Creates and positions the two cloud sprites.
    _sprites.add(_createSprite(image, dark, rotated));
    _sprites[0].position = const Offset(1024.0, 1024.0);
    addChild(_sprites[0]);

    _sprites.add(_createSprite(image, dark, rotated));
    _sprites[1].position = const Offset(3072.0, 1024.0);
    addChild(_sprites[1]);

    // Animates the clouds across the screen.
    motions.run(MotionRepeatForever(MotionTween<Offset>(
        (a) => position = a as Offset,
        Offset.zero,
        const Offset(-2048.0, 0.0),
        loopTime)));
  }

  // ignore: prefer_final_fields
  List<Sprite> _sprites = <Sprite>[];

  Sprite _createSprite(ui.Image image, bool dark, bool rotated) {
    final sprite = Sprite.fromImage(image);

    if (rotated) sprite.scaleX = -1.0;

    if (dark) {
      sprite.colorOverlay = const Color(0xff000000);
      // ignore: cascade_invocations
      sprite.opacity = 0.0;
    }

    return sprite;
  }

  set active(bool active) {
    // Toggle visibility of the cloud layer
    double opacity;
    if (active)
      opacity = 1.0;
    else
      opacity = 0.0;

    for (final sprite in _sprites) {
      sprite.motions.stopAll();
      sprite.motions.run(MotionTween<double>(
          (a) => sprite.opacity = a as double, sprite.opacity, opacity, 1.0));
    }
  }
}

const double _kNumSunRays = 50.0;

// Create an animated sun with rays
class Sun extends Node {
  Sun() {
    // Create the sun
    _sun = new Sprite.fromImage(_images['assets/weather/sun.png']);
    _sun.scale = 4.0;
    _sun.transferMode = BlendMode.plus;
    addChild(_sun);

    // Create rays
    _rays = <Ray>[];
    for (int i = 0; i < _kNumSunRays; i += 1) {
      Ray ray = new Ray();
      addChild(ray);
      _rays.add(ray);
    }
  }

  Sprite _sun;
  List<Ray> _rays;

  set active(bool active) {
    // Toggle visibility of the sun

    motions.stopAll();

    double targetOpacity;
    if (!active)
      targetOpacity = 0.0;
    else
      targetOpacity = 1.0;

    motions.run(MotionTween<double>(
        (a) => _sun.opacity = a as double, _sun.opacity, targetOpacity, 2.0));

    if (active) {
      for (final ray in _rays) {
        motions.run(MotionSequence(<Motion>[
          MotionDelay(1.5),
          MotionTween<double>((a) => ray.opacity = a as double, ray.opacity,
              ray.maxOpacity, 1.5)
        ]));
      }
    } else {
      for (final ray in _rays) {
        motions.run(MotionTween<double>(
            (a) => ray.opacity = a as double, ray.opacity, 0.0, 0.2));
      }
    }
  }
}

// An animated sun ray
class Ray extends Sprite {
  double _rotationSpeed;
  double maxOpacity;

  Ray() : super.fromImage(_images['assets/weather/ray.png']) {
    pivot = const Offset(0.0, 0.5);
    transferMode = BlendMode.plus;
    rotation = randomDouble() * 360.0;
    maxOpacity = randomDouble() * 0.2;
    opacity = maxOpacity;
    scaleX = 2.5 + randomDouble();
    scaleY = 0.3;
    _rotationSpeed = randomSignedDouble() * 2.0;

    // Scale animation
    var scaleTime = randomSignedDouble() * 2.0 + 4.0;

    motions.run(MotionRepeatForever(MotionSequence(<Motion>[
      MotionTween<double>(
          (a) => scaleX = a as double, scaleX, scaleX * 0.5, scaleTime),
      MotionTween<double>(
          (a) => scaleX = a as double, scaleX * 0.5, scaleX, scaleTime)
    ])));
  }

  @override
  void update(double dt) {
    rotation += dt * _rotationSpeed;
  }
}

// Rain layer. Uses three layers of particle systems, to create a parallax
// rain effect.
class Rain extends Node {
  Rain() {
    _addParticles(1.0);
    _addParticles(1.5);
    _addParticles(2.0);
  }

  List<ParticleSystem> _particles = <ParticleSystem>[];

  void _addParticles(double distance) {
    ParticleSystem particles = ParticleSystem(sprites['raindrop.png'],
        transferMode: BlendMode.srcATop,
        posVar: const Offset(1300.0, 0.0),
        direction: 90.0,
        directionVar: 0.0,
        speed: 1000.0 / distance,
        speedVar: 100.0 / distance,
        startSize: 1.2 / distance,
        startSizeVar: 0.2 / distance,
        endSize: 1.2 / distance,
        endSizeVar: 0.2 / distance,
        life: 1.5 * distance,
        lifeVar: 1.0 * distance);
    particles.position = const Offset(1024.0, -200.0);
    particles.rotation = 10.0;
    particles.opacity = 0.0;

    _particles.add(particles);
    addChild(particles);
  }

  set active(bool active) {
    motions.stopAll();
    for (ParticleSystem system in _particles) {
      if (active) {
        motions.run(MotionTween<double>(
            (a) => system.opacity = a as double, system.opacity, 1.0, 2.0));
      } else {
        motions.run(MotionTween<double>(
            (a) => system.opacity = a as double, system.opacity, 0.0, 0.5));
      }
    }
  }
}

// Snow. Uses 9 particle systems to create a parallax effect of snow at
// different distances.
class Snow extends Node {
  Snow() {
    _addParticles(sprites['flake-0.png'], 1.0);
    _addParticles(sprites['flake-1.png'], 1.0);
    _addParticles(sprites['flake-2.png'], 1.0);

    _addParticles(sprites['flake-3.png'], 1.5);
    _addParticles(sprites['flake-4.png'], 1.5);
    _addParticles(sprites['flake-5.png'], 1.5);

    _addParticles(sprites['flake-6.png'], 2.0);
    _addParticles(sprites['flake-7.png'], 2.0);
    _addParticles(sprites['flake-8.png'], 2.0);
  }

  List<ParticleSystem> _particles = <ParticleSystem>[];

  void _addParticles(SpriteTexture texture, double distance) {
    ParticleSystem particles = new ParticleSystem(texture,
        transferMode: BlendMode.srcATop,
        posVar: const Offset(1300.0, 0.0),
        direction: 90.0,
        directionVar: 0.0,
        speed: 150.0 / distance,
        speedVar: 50.0 / distance,
        startSize: 1.0 / distance,
        startSizeVar: 0.3 / distance,
        endSize: 1.2 / distance,
        endSizeVar: 0.2 / distance,
        life: 20.0 * distance,
        lifeVar: 10.0 * distance,
        emissionRate: 2.0,
        startRotationVar: 360.0,
        endRotationVar: 360.0,
        radialAccelerationVar: 10.0 / distance,
        tangentialAccelerationVar: 10.0 / distance);
    particles.position = const Offset(1024.0, -50.0);
    particles.opacity = 0.0;

    _particles.add(particles);
    addChild(particles);
  }

  set active(bool active) {
    motions.stopAll();
    for (ParticleSystem system in _particles) {
      if (active) {
        motions.run(MotionTween<double>(
            (a) => system.opacity = a as double, system.opacity, 1.0, 2.0));
      } else {
        motions.run(MotionTween<double>(
            (a) => system.opacity = a as double, system.opacity, 0.0, 0.5));
      }
    }
  }
}
