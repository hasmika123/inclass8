import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fading Text Animation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isDarkMode = false;
  Color _textColor = Colors.blue;
  PageController _pageController = PageController();
  GlobalKey<_FadingTextScreenState> _fadingTextKey = GlobalKey();
  int _currentPage = 0;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _textColor,
              onColorChanged: (color) {
                setState(() {
                  _textColor = color;
                });
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void _onFloatingActionButtonPressed() {
    // Only trigger on the first page (FadingTextScreen)
    if (_currentPage == 0 && _fadingTextKey.currentState != null) {
      _fadingTextKey.currentState!.toggleVisibility();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fading Text Animation'),
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
              onPressed: _toggleTheme,
            ),
            IconButton(
              icon: const Icon(Icons.palette),
              onPressed: _openColorPicker,
            ),
            const SizedBox(width: 60), // Add extra space to avoid debug banner
          ],
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          children: [
            FadingTextScreen(key: _fadingTextKey, textColor: _textColor),
            SecondFadingScreen(textColor: _textColor),
            ImageAnimationScreen(),
          ],
        ),
        floatingActionButton: _currentPage == 0 ? FloatingActionButton(
          onPressed: _onFloatingActionButtonPressed,
          child: const Icon(Icons.play_arrow),
        ) : null,
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          child: const Text(
            'Swipe left/right to see different animations →',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          ),
        ),
      ),
    );
  }
}

class FadingTextScreen extends StatefulWidget {
  final Color textColor;

  const FadingTextScreen({Key? key, required this.textColor}) : super(key: key);

  @override
  _FadingTextScreenState createState() => _FadingTextScreenState();
}

class _FadingTextScreenState extends State<FadingTextScreen>
    with SingleTickerProviderStateMixin {
  bool _isVisible = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Screen 1: Tap Text Animation',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: toggleVisibility,
            child: AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              child: Text(
                'Hello, Flutter!',
                style: TextStyle(
                  fontSize: 24,
                  color: widget.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Enhanced: Tap the text directly for interaction!\n(Or use the play button below)',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 40),
          FadeTransition(
            opacity: _animation,
            child: Text(
              'Continuous Fading Animation',
              style: TextStyle(
                fontSize: 20,
                color: widget.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SecondFadingScreen extends StatefulWidget {
  final Color textColor;

  const SecondFadingScreen({Key? key, required this.textColor}) : super(key: key);

  @override
  _SecondFadingScreenState createState() => _SecondFadingScreenState();
}

class _SecondFadingScreenState extends State<SecondFadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _fastController;
  late AnimationController _slowController;
  late Animation<double> _fastAnimation;
  late Animation<double> _slowAnimation;

  @override
  void initState() {
    super.initState();
    
    _fastController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _fastAnimation = CurvedAnimation(
      parent: _fastController,
      curve: Curves.bounceInOut,
    );
    
    _slowAnimation = CurvedAnimation(
      parent: _slowController,
      curve: Curves.elasticInOut,
    );
    
    _fastController.repeat(reverse: true);
    _slowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fastController.dispose();
    _slowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Screen 2: Different Animation Durations',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          FadeTransition(
            opacity: _fastAnimation,
            child: Text(
              'Fast Animation (800ms)',
              style: TextStyle(
                fontSize: 22,
                color: widget.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 40),
          FadeTransition(
            opacity: _slowAnimation,
            child: Text(
              'Slow Animation (3s)',
              style: TextStyle(
                fontSize: 22,
                color: widget.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 40),
          AnimatedBuilder(
            animation: _fastController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _fastController.value * 2 * 3.14159,
                child: Text(
                  'Rotating Text!',
                  style: TextStyle(
                    fontSize: 18,
                    color: widget.textColor,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ImageAnimationScreen extends StatefulWidget {
  @override
  _ImageAnimationScreenState createState() => _ImageAnimationScreenState();
}

class _ImageAnimationScreenState extends State<ImageAnimationScreen>
    with TickerProviderStateMixin {
  bool _showFrame = true; // Start with frame ON (rounded corners)
  bool _isImageVisible = true;
  late AnimationController _rotationController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _rotationController.repeat();
    _fadeController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _toggleImageVisibility() {
    setState(() {
      _isImageVisible = !_isImageVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Screen 3: Image Animations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Frame Toggle Switch
            SwitchListTile(
              title: const Text('Show Rounded Frame'),
              value: _showFrame,
              onChanged: (bool value) {
                setState(() {
                  _showFrame = value;
                });
              },
            ),
            
            const SizedBox(height: 20),
            
            // Fading Image
            GestureDetector(
              onTap: _toggleImageVisibility,
              child: AnimatedOpacity(
                opacity: _isImageVisible ? 1.0 : 0.3,
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_showFrame ? 15 : 0), // Sharp vs rounded
                    child: Image.asset(
                      'assets/golden-retriever-tongue-out.jpg',
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(_showFrame ? 15 : 0),
                          ),
                          child: const Icon(
                            Icons.image,
                            size: 100,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            const Text(
              'Tap image to fade in/out',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
            
            const SizedBox(height: 30),
            
            // Rotating Image
            AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationController.value * 2 * 3.14159,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.pets,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 10),
            const Text(
              'Rotating Icon',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
            
            const SizedBox(height: 30),
            
            // Continuously Fading Image
            FadeTransition(
              opacity: _fadeController,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.purple, Colors.pink],
                  ),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: const Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            const Text(
              'Continuous Fade Animation',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
} 