import 'package:flutter/material.dart';
import '../data/app_user.dart';
import '../theme/app_colors.dart';
import '../widgets/brand_mark.dart';
import 'onboarding_screen.dart';

class _PasswordRule {
  final String label;
  final bool Function(String) test;
  const _PasswordRule(this.label, this.test);
}

final List<_PasswordRule> _passwordRules = [
  _PasswordRule('Mínimo de 8 caracteres', (p) => p.length >= 8),
  _PasswordRule('Pelo menos 1 número', (p) => RegExp(r'\d').hasMatch(p)),
  _PasswordRule(
    'Maiúscula e minúscula',
    (p) => RegExp(r'[a-z]').hasMatch(p) && RegExp(r'[A-Z]').hasMatch(p),
  ),
];

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirm = false;
  bool _accepted = false;
  bool _touched = false;
  bool _submitted = false;

  static final _emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  bool get _emailValid => _emailRegex.hasMatch(_emailController.text);

  bool get _rulesPassed =>
      _passwordRules.every((r) => r.test(_passwordController.text));

  bool get _passwordsMatch =>
      _confirmController.text.isNotEmpty &&
      _passwordController.text == _confirmController.text;

  bool get _formValid =>
      _nameController.text.trim().length > 1 &&
      _emailValid &&
      _rulesPassed &&
      _passwordsMatch &&
      _accepted;

  void _handleSubmit() {
    setState(() => _touched = true);
    if (_formValid) {
      AppUser.name = _nameController.text.trim();
      setState(() => _submitted = true);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: _submitted
                  ? _SuccessView(
                      email: _emailController.text,
                      onContinue: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                        );
                      },
                    )
                  : _buildForm(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BrandMark(logoSize: 30),
        const SizedBox(height: 22),
        const Text(
          'Crie sua conta',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Sua sequência começa aqui. Crie sua conta para dar o primeiro passo hoje.',
          style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary, height: 1.5),
        ),
        const SizedBox(height: 22),
        _Field(
          label: 'Nome',
          child: TextField(
            controller: _nameController,
            decoration: _inputDecoration('Como podemos te chamar?'),
            onChanged: (_) => setState(() {}),
          ),
        ),
        const SizedBox(height: 16),
        _Field(
          label: 'E-mail',
          error: _touched && _emailController.text.isNotEmpty && !_emailValid
              ? 'E-mail inválido'
              : null,
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDecoration('voce@exemplo.com'),
            onChanged: (_) => setState(() {}),
          ),
        ),
        const SizedBox(height: 16),
        _Field(
          label: 'Senha',
          child: TextField(
            controller: _passwordController,
            obscureText: !_showPassword,
            decoration: _inputDecoration('Crie uma senha').copyWith(
              suffixIcon: IconButton(
                icon: Icon(
                  _showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 19,
                  color: AppColors.textSecondary,
                ),
                onPressed: () => setState(() => _showPassword = !_showPassword),
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
        if (_passwordController.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          ..._passwordRules.map((r) {
            final ok = r.test(_passwordController.text);
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ok ? AppColors.primary : AppColors.divider,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    r.label,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: ok ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
        const SizedBox(height: 16),
        _Field(
          label: 'Confirmar senha',
          error: _touched && _confirmController.text.isNotEmpty && !_passwordsMatch
              ? 'As senhas não coincidem'
              : null,
          child: TextField(
            controller: _confirmController,
            obscureText: !_showConfirm,
            decoration: _inputDecoration('Repita a senha').copyWith(
              suffixIcon: IconButton(
                icon: Icon(
                  _showConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 19,
                  color: AppColors.textSecondary,
                ),
                onPressed: () => setState(() => _showConfirm = !_showConfirm),
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: _accepted,
              activeColor: AppColors.primary,
              onChanged: (v) => setState(() => _accepted = v ?? false),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.5),
                    children: [
                      const TextSpan(text: 'Aceito os '),
                      TextSpan(
                        text: 'termos de uso',
                        style: const TextStyle(color: AppColors.primary, decoration: TextDecoration.underline),
                      ),
                      const TextSpan(text: ' e a '),
                      TextSpan(
                        text: 'política de privacidade',
                        style: const TextStyle(color: AppColors.primary, decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_touched && !_formValid) ...[
          const SizedBox(height: 4),
          const Text(
            'Revise os campos destacados antes de continuar.',
            style: TextStyle(fontSize: 12, color: AppColors.statusParada),
          ),
        ],
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _handleSubmit,
            child: const Text('Criar minha conta'),
          ),
        ),
        const SizedBox(height: 18),
        Center(
          child: RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
              children: [
                TextSpan(text: 'Já tem uma conta? '),
                TextSpan(
                  text: 'Entrar',
                  style: TextStyle(color: AppColors.primary, decoration: TextDecoration.underline),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final Widget child;
  final String? error;

  const _Field({required this.label, required this.child, this.error});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        child,
        if (error != null) ...[
          const SizedBox(height: 4),
          Text(error!, style: const TextStyle(fontSize: 11.5, color: AppColors.statusParada)),
        ],
      ],
    );
  }
}

class _SuccessView extends StatelessWidget {
  final String email;
  final VoidCallback onContinue;

  const _SuccessView({required this.email, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle, color: AppColors.primary, size: 32),
        ),
        const SizedBox(height: 20),
        const Text(
          'Conta criada!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 10),
        Text.rich(
          TextSpan(
            style: const TextStyle(fontSize: 13.5, color: AppColors.textSecondary, height: 1.5),
            children: [
              const TextSpan(text: 'Enviamos um e-mail de confirmação para '),
              TextSpan(text: email, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const TextSpan(text: '. Confirme para começar seu primeiro ciclo de foco.'),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onContinue,
            child: const Text('Continuar'),
          ),
        ),
      ],
    );
  }
}
