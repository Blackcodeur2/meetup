import 'package:flutter/material.dart';
import 'package:meetup/controllers/AuthController.dart';
import 'package:meetup/views/auth/login.dart';

class LoveAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool showLogoutButton;
  final VoidCallback? onBackPressed;

  const LoveAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.showBackButton = false,
    this.onBackPressed,
    required this.showLogoutButton,
  });

  @override
  State<LoveAppBar> createState() => _LoveAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 25);
}

class _LoveAppBarState extends State<LoveAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _logout() async {
    await AuthController.signOut();
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  } 

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //final authService = AuthService();

  /*void _logout() async {
    await authService.logoutUser();
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }*/
  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight + 25,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE91E63), Color(0xFF9C27B0)], // Rose -> Violet
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              if (widget.showBackButton)
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed:
                      widget.onBackPressed ?? () => Navigator.pop(context),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    if (widget.subtitle != null)
                      Text(
                        widget.subtitle!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                  ],
                ),
              ),

              // ===== Ajout du ThemeSwitcher =====
              if (widget.actions != null) ...widget.actions!,
              IconButton(onPressed: () {}, icon: const Icon(Icons.logout))
            ],
          ),
        ),
      ),
    );
  }
}
