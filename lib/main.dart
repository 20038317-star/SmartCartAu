import 'package:flutter/material.dart';

const cream = Color(0xFFF8F6EB);
const darkGreen = Color(0xFF06351B);
const green = Color(0xFF0B6B2C);
const green2 = Color(0xFF157A35);
const paleGreen = Color(0xFFE8F6E9);
const line = Color(0xFFD9DDD4);
const muted = Color(0xFF6B756D);
const white = Color(0xFFFFFFFF);
const red = Color(0xFFB83232);
bool _highContrast = false;

void main() => runApp(const SmartCartApp());

class SmartCartApp extends StatefulWidget {
  const SmartCartApp({super.key});
  @override
  State<SmartCartApp> createState() => _SmartCartAppState();
}

class _SmartCartAppState extends State<SmartCartApp> {
  bool largerText = false;
  bool highContrast = false;
  bool reduceMotion = false;
  bool screenReaderLabels = true;

  @override
  Widget build(BuildContext context) {
    _highContrast = highContrast;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartCart AU',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(seedColor: green),
        fontFamily: 'sans-serif',
      ),
      builder: (context, child) {
        final scale = largerText ? 1.14 : 1.0;
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        );
      },
      home: SignInPage(
        onSignedIn: (context) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage(settings: this)),
        ),
        onGuest: (context) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage(settings: this, guest: true)),
        ),
      ),
    );
  }
}

class SignInPage extends StatefulWidget {
  final void Function(BuildContext) onSignedIn;
  final void Function(BuildContext) onGuest;
  const SignInPage({super.key, required this.onSignedIn, required this.onGuest});
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppShell(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(28, 28, 28, 30),
            decoration: const BoxDecoration(
              color: darkGreen,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(26), bottomRight: Radius.circular(26)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('SmartCart AU', style: t(29, white, FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text('Plan • Compare • Save', style: t(12, white, FontWeight.w600)),
                    const SizedBox(height: 18),
                    Text('A simpler grocery shop built around\nyour budget, dietary needs and\ntime.', style: t(14, white, FontWeight.w500, height: 1.2)),
                  ]),
                ),
                CircleAvatar(radius: 28, backgroundColor: green2, child: Text('SC', style: t(13, white, FontWeight.w800))),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Welcome back', style: t(24, darkGreen, FontWeight.w800)),
                const SizedBox(height: 3),
                Text('Sign in to continue your weekly shop.', style: t(13, muted, FontWeight.w500)),
                const SizedBox(height: 20),
                InputField(controller: email, hint: 'Email address', icon: Icons.mail_outline),
                const SizedBox(height: 10),
                InputField(controller: password, hint: 'Password', icon: Icons.lock_outline, obscure: true),
                const SizedBox(height: 16),
                PrimaryButton(label: 'Sign in', onTap: () => widget.onSignedIn(context)),
                const SizedBox(height: 10),
                OutlineButton(label: 'Continue as guest', onTap: () => widget.onGuest(context)),
                const SizedBox(height: 18),
                Text('By continuing you agree to the privacy notice.', style: t(10.5, muted, FontWeight.w500)),
                const SizedBox(height: 14),
                Text('Accessible mode available in Profile', style: t(11, green, FontWeight.w700)),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(color: _highContrast ? Colors.white : cream, border: Border.all(color: _highContrast ? Colors.black : line)),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

TextStyle t(double size, Color color, FontWeight weight, {double height = 1.0}) => TextStyle(
  fontSize: size,
  color: _highContrast && color == muted ? Colors.black87 : color,
  fontWeight: weight,
  height: height,
  letterSpacing: size >= 18 ? .2 : .1,
);

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  final bool obscure;
  const InputField({super.key, required this.controller, required this.hint, this.icon, this.obscure = false});
  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    obscureText: obscure,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: t(13, muted, FontWeight.w500),
      prefixIcon: icon == null ? null : Icon(icon, size: 19, color: muted),
      filled: true,
      fillColor: white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: line)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: green, width: 1.5)),
    ),
  );
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  const PrimaryButton({super.key, required this.label, required this.onTap, this.icon});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 48,
    child: ElevatedButton.icon(
      onPressed: onTap,
      icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 18),
      label: Text(label, style: t(13, white, FontWeight.w800)),
      style: ElevatedButton.styleFrom(
        backgroundColor: green,
        foregroundColor: white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
    ),
  );
}

class OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const OutlineButton({super.key, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 44,
    child: OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: green,
        side: const BorderSide(color: green),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(label, style: t(13, green, FontWeight.w800)),
    ),
  );
}

class AppHeader extends StatelessWidget {
  final String title;
  final VoidCallback? back;
  final List<Widget> actions;
  const AppHeader({super.key, required this.title, this.back, this.actions = const []});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(28, 10, 28, 10),
    child: Row(children: [
      if (back != null)
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Semantics(
            label: 'Go back',
            button: true,
            child: InkWell(
              onTap: back,
              borderRadius: BorderRadius.circular(18),
              child: Container(width: 34, height: 34, decoration: BoxDecoration(color: white, border: Border.all(color: line), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.chevron_left, size: 20)),
            ),
          ),
        ),
      Expanded(child: Text(title, style: t(23, darkGreen, FontWeight.w800))),
      if (actions.isNotEmpty) ...actions,
    ]),
  );
}

class BottomNav extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelected;
  const BottomNav({super.key, required this.selected, required this.onSelected});
  @override
  Widget build(BuildContext context) {
    const labels = ['Home', 'Search', 'List', 'Orders', 'Profile'];
    const icons = [Icons.home_outlined, Icons.search, Icons.list_alt_outlined, Icons.receipt_long_outlined, Icons.person_outline];
    return Container(
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: line))),
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 7),
      child: Row(
        children: List.generate(5, (i) => Expanded(
          child: InkWell(
            onTap: () => onSelected(i),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(color: selected == i ? paleGreen : Colors.transparent, borderRadius: BorderRadius.circular(18)),
              child: Column(children: [
                Icon(icons[i], size: 18, color: selected == i ? darkGreen : muted),
                const SizedBox(height: 2),
                Text(labels[i], style: t(9, selected == i ? darkGreen : muted, FontWeight.w700)),
              ]),
            ),
          ),
        )),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final _SmartCartAppState settings;
  final bool guest;
  const HomePage({super.key, required this.settings, this.guest = false});

  void nav(BuildContext context, int i) {
    final pages = [
      HomePage(settings: settings, guest: guest),
      SearchPage(settings: settings),
      SmartListPage(settings: settings),
      OrdersPage(settings: settings),
      ProfilePage(settings: settings),
    ];
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => pages[i]));
  }

  @override
  Widget build(BuildContext context) => AppShell(child: Column(children: [
    Expanded(child: SingleChildScrollView(child: Padding(
      padding: const EdgeInsets.fromLTRB(28, 10, 28, 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Expanded(child: Text(guest ? 'Good evening, Guest' : 'Good evening, Alex', style: t(13, muted, FontWeight.w600))), const Icon(Icons.more_horiz, size: 24)]),
        const SizedBox(height: 6),
        Text('What are we shopping for?', style: t(23, darkGreen, FontWeight.w800)),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SearchPage(settings: settings))),
          borderRadius: BorderRadius.circular(16),
          child: Container(height: 46, padding: const EdgeInsets.symmetric(horizontal: 15), decoration: BoxDecoration(color: white, border: Border.all(color: line), borderRadius: BorderRadius.circular(16)), child: Row(children: [const Icon(Icons.search, size: 19, color: muted), const SizedBox(width: 8), Text('Search groceries, brands or categories', style: t(12, muted, FontWeight.w500))])),
        ),
        const SizedBox(height: 12),
        Wrap(spacing: 8, children: ['Dietary', 'On sale', 'Under \$10'].map((x) => Chip(label: Text(x, style: t(10.5, green, FontWeight.w700)), backgroundColor: paleGreen, side: BorderSide.none, padding: const EdgeInsets.symmetric(horizontal: 5))).toList()),
        const SizedBox(height: 20),
        SectionTitle(title: 'Quick actions'),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: QuickCard(title: 'Smart List', value: '8 items', onTap: () => nav(context, 2))),
          const SizedBox(width: 9),
          Expanded(child: QuickCard(title: 'Budget', value: '\$37 left', selected: true, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage(settings: settings))))),
          const SizedBox(width: 9),
          Expanded(child: QuickCard(title: 'Rewards', value: '2,140 pts', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage(settings: settings))))),
        ]),
        const SizedBox(height: 20),
        Row(children: [Expanded(child: SectionTitle(title: 'Recommended')), Text('See all', style: t(10, green, FontWeight.w800))]),
        const SizedBox(height: 9),
        Row(children: [Expanded(child: ProductCard(product: products[0], onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailsPage(settings: settings, product: products[0]))))), const SizedBox(width: 10), Expanded(child: ProductCard(product: products[1], onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailsPage(settings: settings, product: products[1])))))]),
        const SizedBox(height: 20),
        SectionTitle(title: 'Next delivery'),
        const SizedBox(height: 8),
        InfoCard(child: Row(children: [CircleAvatar(radius: 17, backgroundColor: green, child: Text('D', style: t(12, white, FontWeight.w800))), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Tomorrow • 6–8 PM', style: t(13, darkGreen, FontWeight.w800)), const SizedBox(height: 3), Text('12 items • Picking starts at 4 PM', style: t(10.5, muted, FontWeight.w500))])), Text('FREE', style: t(11, green, FontWeight.w800))])),
      ],
    ),
    ))),
    BottomNav(selected: 0, onSelected: (i) => nav(context, i)),
  ]));
}

class QuickCard extends StatelessWidget {
  final String title, value;
  final bool selected;
  final VoidCallback onTap;
  const QuickCard({super.key, required this.title, required this.value, required this.onTap, this.selected = false});
  @override
  Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(15), child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: selected ? darkGreen : white, border: Border.all(color: selected ? darkGreen : line), borderRadius: BorderRadius.circular(15)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: t(10, selected ? white : darkGreen, FontWeight.w700)), const SizedBox(height: 7), Text(value, style: t(12, selected ? const Color(0xFFBFE4A7) : green, FontWeight.w800))])));
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});
  @override
  Widget build(BuildContext context) => Text(title, style: t(14, darkGreen, FontWeight.w800));
}

class InfoCard extends StatelessWidget {
  final Widget child;
  const InfoCard({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Container(width: double.infinity, padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: paleGreen, border: Border.all(color: const Color(0xFF87B48D)), borderRadius: BorderRadius.circular(17)), child: child);
}

class Product {
  final String name, price, type, tag;
  const Product(this.name, this.price, this.type, this.tag);
}

const products = [
  Product('Fresh Milk 2L', '\$3.60', 'milk', 'BEST VALUE'),
  Product('Wholegrain bread', '\$4.50', 'bread', ''),
  Product('Bananas 1kg', '\$4.20', 'banana', ''),
  Product('Lactose Free', '\$4.80', 'milk', 'DIETARY MATCH'),
  Product('Oat Milk 1L', '\$3.95', 'oat', ''),
  Product('Almond Milk', '\$4.20', 'oat', ''),
  Product('Eggs 12 pack', '\$5.80', 'eggs', ''),
  Product('Chicken breast', '\$11.50', 'chicken', ''),
  Product('Premium cereal 500g', '\$8.50', 'cereal', ''),
];

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  const ProductCard({super.key, required this.product, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(17),
    child: Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(color: white, border: Border.all(color: line), borderRadius: BorderRadius.circular(17), boxShadow: const [BoxShadow(blurRadius: 7, color: Color(0x11000000), offset: Offset(0, 3))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ProductArt(type: product.type, height: 62),
        const SizedBox(height: 7),
        Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: t(11, darkGreen, FontWeight.w800)),
        const SizedBox(height: 3),
        Row(children: [Expanded(child: Text(product.price, style: t(13, green, FontWeight.w800))), Container(width: 28, height: 28, decoration: const BoxDecoration(color: green, shape: BoxShape.circle), child: const Icon(Icons.add, color: white, size: 17))]),
        if (product.tag.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 3), child: Text(product.tag, style: t(8, const Color(0xFFD99D00), FontWeight.w800))),
      ]),
    ),
  );
}

class ProductArt extends StatelessWidget {
  final String type;
  final double height;
  const ProductArt({super.key, required this.type, this.height = 90});
  @override
  Widget build(BuildContext context) => Container(
    height: height,
    width: double.infinity,
    decoration: BoxDecoration(color: const Color(0xFFEAF7EE), borderRadius: BorderRadius.circular(13)),
    child: CustomPaint(painter: GroceryPainter(type)),
  );
}

class GroceryPainter extends CustomPainter {
  final String type;
  GroceryPainter(this.type);
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    final stroke = Paint()..style = PaintingStyle.stroke..strokeWidth = 1.5..color = green;
    final cx = s.width / 2;
    if (type == 'milk') {
      p.color = white; canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, s.height * .55), width: s.width * .27, height: s.height * .56), const Radius.circular(5)), p);
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, s.height * .25), width: s.width * .18, height: s.height * .12), const Radius.circular(3)), p);
      canvas.drawLine(Offset(cx - s.width*.09, s.height*.3), Offset(cx + s.width*.09, s.height*.3), stroke);
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, s.height*.56), width: s.width*.16, height: s.height*.13), const Radius.circular(3)), Paint()..color = green);
      final tp = TextPainter(text: TextSpan(text: 'MILK', style: t(6, white, FontWeight.w800)), textDirection: TextDirection.ltr)..layout(); tp.paint(canvas, Offset(cx-tp.width/2, s.height*.52));
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, s.height*.55), width: s.width*.27, height: s.height*.56), const Radius.circular(5)), stroke);
    } else if (type == 'bread' || type == 'cereal') {
      p.color = type == 'bread' ? const Color(0xFFF0B84F) : const Color(0xFFE7B45A);
      canvas.drawOval(Rect.fromLTWH(cx-s.width*.29, s.height*.37, s.width*.58, s.height*.30), p);
      canvas.drawOval(Rect.fromLTWH(cx-s.width*.24, s.height*.25, s.width*.24, s.height*.25), p);
      canvas.drawOval(Rect.fromLTWH(cx-s.width*.02, s.height*.21, s.width*.25, s.height*.28), p);
      if (type == 'cereal') canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(cx-s.width*.14, s.height*.30, s.width*.28, s.height*.36), const Radius.circular(5)), Paint()..color = white..style = PaintingStyle.stroke..strokeWidth = 2);
    } else if (type == 'banana') {
      p.color = const Color(0xFFF6D51F); final path = Path()..moveTo(cx-s.width*.31, s.height*.40)..quadraticBezierTo(cx-s.width*.05, s.height*.72, cx+s.width*.28, s.height*.42)..quadraticBezierTo(cx+s.width*.08, s.height*.76, cx-s.width*.31, s.height*.40)..close(); canvas.drawPath(path, p);
    } else if (type == 'oat') {
      p.color = const Color(0xFFB9E86E); canvas.drawCircle(Offset(cx, s.height*.36), s.height*.19, p); p.color = green; canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, s.height*.60), width: s.width*.22, height: s.height*.28), const Radius.circular(5)), p);
    } else if (type == 'eggs') {
      p.color = white; for (int i=0;i<3;i++) canvas.drawOval(Rect.fromCenter(center: Offset(cx+(i-1)*s.width*.15, s.height*.53), width: s.width*.17, height: s.height*.30), p);
      for (int i=0;i<3;i++) canvas.drawOval(Rect.fromCenter(center: Offset(cx+(i-1)*s.width*.15, s.height*.53), width: s.width*.17, height: s.height*.30), stroke);
    } else {
      p.color = const Color(0xFFF0CBA6); canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, s.height*.52), width: s.width*.46, height: s.height*.30), const Radius.circular(8)), p);
    }
  }
  @override
  bool shouldRepaint(covariant GroceryPainter oldDelegate) => oldDelegate.type != type;
}

class SearchPage extends StatefulWidget {
  final _SmartCartAppState settings;
  const SearchPage({super.key, required this.settings});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final query = TextEditingController(text: 'milk');
  String filter = 'Low price';
  List<Product> get matches {
    final q = query.text.toLowerCase();
    final list = products.where((p) => p.name.toLowerCase().contains(q) || p.type.contains(q)).toList();
    if (filter == 'Low price') list.sort((a,b)=>double.parse(a.price.substring(1)).compareTo(double.parse(b.price.substring(1))));
    return list;
  }
  void nav(BuildContext context, int i) {
    final pages = [HomePage(settings: widget.settings), SearchPage(settings: widget.settings), SmartListPage(settings: widget.settings), OrdersPage(settings: widget.settings), ProfilePage(settings: widget.settings)];
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => pages[i]));
  }
  @override
  Widget build(BuildContext context) => AppShell(child: Column(children: [
    Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(28, 10, 28, 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      AppHeader(title: 'Find products', back: () => Navigator.pop(context)),
      Text('24 results for “${query.text}”', style: t(11, muted, FontWeight.w500)),
      const SizedBox(height: 10),
      TextField(controller: query, onChanged: (_) => setState(() {}), decoration: InputDecoration(prefixIcon: const Icon(Icons.search, size: 18), hintText: 'Find products', filled: true, fillColor: white, contentPadding: const EdgeInsets.symmetric(vertical: 12), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: green)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: green, width: 1.5)))),
      const SizedBox(height: 9),
      SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: ['Low price','Lactose free','4★ & up','More filters'].map((x) => Padding(padding: const EdgeInsets.only(right: 7), child: ChoiceChip(label: Text(x, style: t(10, filter==x?white:green, FontWeight.w700)), selected: filter==x, onSelected: (_) => setState(() => filter=x), selectedColor: green, backgroundColor: paleGreen, side: BorderSide.none))).toList())),
      const SizedBox(height: 15),
      GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: matches.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: .92), itemBuilder: (_, i) => ProductCard(product: matches[i], onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailsPage(settings: widget.settings, product: matches[i]))))),
      const SizedBox(height: 10),
      Text('Sort: Recommended', style: t(10.5, muted, FontWeight.w600)),
    ]))),
    BottomNav(selected: 1, onSelected: (i) => nav(context, i)),
  ]));
}

class ProductDetailsPage extends StatelessWidget {
  final _SmartCartAppState settings;
  final Product product;
  const ProductDetailsPage({super.key, required this.settings, required this.product});
  @override
  Widget build(BuildContext context) => AppShell(child: Column(children: [
    Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(28, 10, 28, 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      AppHeader(title: 'Product details', back: () => Navigator.pop(context)),
      Row(children: [Expanded(child: ProductArt(type: product.type, height: 112)), const SizedBox(width: 12), Expanded(child: Container(padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: white, border: Border.all(color: line), borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(product.name, style: t(15, darkGreen, FontWeight.w800)), const SizedBox(height: 4), Text('Woolworths • Chilled', style: t(10, muted, FontWeight.w500)), const SizedBox(height: 4), Text(product.price, style: t(18, green, FontWeight.w800))])))]),
      const SizedBox(height: 12),
      Wrap(spacing: 7, children: ['Best value','Australian','Nut free'].map((x) => Chip(label: Text(x, style: t(9.5, green, FontWeight.w700)), backgroundColor: paleGreen, side: BorderSide.none)).toList()),
      const SizedBox(height: 14),
      SectionTitle(title: 'Why it fits'), const SizedBox(height: 7),
      InfoCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Matches your saved preferences', style: t(11.5, darkGreen, FontWeight.w800)), const SizedBox(height: 4), Text('No nut allergens detected • within weekly budget', style: t(10, muted, FontWeight.w500))])),
      const SizedBox(height: 18),
      SectionTitle(title: 'Price comparison'), const SizedBox(height: 7),
      InfoCard(child: Column(children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Your selected store', style: t(10, muted, FontWeight.w500)), Text(product.price, style: t(11, green, FontWeight.w800))]), const SizedBox(height: 6), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Alternative store', style: t(10, muted, FontWeight.w500)), Text('\$3.75', style: t(11, darkGreen, FontWeight.w700))])])),
      const SizedBox(height: 18),
      Row(children: [Expanded(child: SectionTitle(title: 'Nutrition & details')), Text('View all', style: t(10, green, FontWeight.w800))]),
      const SizedBox(height: 7), Text('2L • Full cream • Refrigerated', style: t(11, muted, FontWeight.w500)),
    ]))),
    Padding(padding: const EdgeInsets.fromLTRB(28, 0, 28, 14), child: PrimaryButton(label: 'Add to cart • ${product.price}', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage(settings: settings))))),
  ]));
}

class SmartListPage extends StatefulWidget {
  final _SmartCartAppState settings;
  const SmartListPage({super.key, required this.settings});
  @override
  State<SmartListPage> createState() => _SmartListPageState();
}

class _SmartListPageState extends State<SmartListPage> {
  final items = <String>['Milk 2L','Wholegrain bread','Bananas 1kg','Eggs 12 pack','Chicken breast'];
  final prices = <String>['\$3.60','\$4.50','\$4.20','\$5.80','\$11.50'];
  final qty = <int>[1,1,1,1,1];
  void nav(BuildContext context, int i) {
    final pages = [HomePage(settings: widget.settings), SearchPage(settings: widget.settings), SmartListPage(settings: widget.settings), OrdersPage(settings: widget.settings), ProfilePage(settings: widget.settings)];
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => pages[i]));
  }
  @override
  Widget build(BuildContext context) => AppShell(child: Column(children: [
    Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(28, 10, 28, 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Smart List', style: t(23, darkGreen, FontWeight.w800)), const SizedBox(height: 3), Text('Plan the week before you start shopping.', style: t(11, muted, FontWeight.w500)),
      const SizedBox(height: 14),
      Container(height: 43, padding: const EdgeInsets.symmetric(horizontal: 14), decoration: BoxDecoration(color: white, border: Border.all(color: line), borderRadius: BorderRadius.circular(16)), child: Row(children: [const Icon(Icons.add, size: 17, color: muted), const SizedBox(width: 7), Text('Add milk, bananas, dinner ingredients...', style: t(11.5, muted, FontWeight.w500))])),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: darkGreen, borderRadius: BorderRadius.circular(17)),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Weekly budget', style: t(9.5, const Color(0xFFBFE4A7), FontWeight.w700)),
            const SizedBox(height: 4),
            Text('\$42.70 of \$80', style: t(17, white, FontWeight.w800)),
          ])),
          const SizedBox(width: 14),
          Expanded(child: Column(children: [
            Container(height: 5, decoration: BoxDecoration(color: const Color(0xFFBFE4A7), borderRadius: BorderRadius.circular(5))),
            const SizedBox(height: 4),
            Align(alignment: Alignment.centerRight, child: Text('8 items', style: t(8.5, white, FontWeight.w500))),
          ])),
        ]),
      ),
      const SizedBox(height: 12),
      ...List.generate(items.length, (i) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(color: white, border: Border.all(color: line), borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(blurRadius: 5, color: Color(0x0D000000), offset: Offset(0, 2))]),
          child: Row(children: [
            Container(width: 28, height: 28, decoration: const BoxDecoration(color: paleGreen, shape: BoxShape.circle), child: const Icon(Icons.check, color: green, size: 16)),
            const SizedBox(width: 9),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(items[i], style: t(11, darkGreen, FontWeight.w800)), Text(prices[i], style: t(9.5, muted, FontWeight.w500))])),
            IconButton(onPressed: () => setState(() => qty[i] = (qty[i] - 1).clamp(0, 9)), icon: const Icon(Icons.remove, size: 15)),
            Text('${qty[i]}', style: t(10, darkGreen, FontWeight.w800)),
            IconButton(onPressed: () => setState(() => qty[i]++), icon: const Icon(Icons.add, size: 15)),
          ]),
        ),
      )),
      const SizedBox(height: 5), PrimaryButton(label: 'Shop this list', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage(settings: widget.settings)))),
    ]))),
    BottomNav(selected: 2, onSelected: (i) => nav(context, i)),
  ]));
}

class CartPage extends StatefulWidget {
  final _SmartCartAppState settings;
  const CartPage({super.key, required this.settings});
  @override
  State<CartPage> createState() => _CartPageState();
}
class _CartPageState extends State<CartPage> {
  final items = <Product>[products[0],products[1],products[2]];
  final qty = <int>[1,1,1];
  double get total => 3.6*qty[0]+4.5*qty[1]+4.2*qty[2];
  @override
  Widget build(BuildContext context) => AppShell(child: Column(children: [
    Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(28, 10, 28, 18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      AppHeader(title: 'Cart', back: () => Navigator.pop(context)),
      Text('4 items • budget-aware basket', style: t(11, muted, FontWeight.w500)), const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: darkGreen, borderRadius: BorderRadius.circular(17)),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('You are under budget', style: t(9.5, const Color(0xFFBFE4A7), FontWeight.w700)),
            const SizedBox(height: 4),
            Text('\$${total.toStringAsFixed(2)} / \$80.00', style: t(17, white, FontWeight.w800)),
          ])),
          Text('\$${(80-total).toStringAsFixed(2)} remaining', style: t(9.5, const Color(0xFFBFE4A7), FontWeight.w700)),
        ]),
      ),
      const SizedBox(height: 12),
      ...List.generate(items.length, (i) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: CartItem(
          product: items[i],
          qty: qty[i],
          onMinus: () => setState(() => qty[i] = (qty[i] - 1).clamp(1, 9)),
          onPlus: () => setState(() => qty[i]++),
        ),
      )),
      const SizedBox(height: 5),
      InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SmartAlternativesPage(settings: widget.settings))), child: InfoCard(child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Save another \$5.40', style: t(11, darkGreen, FontWeight.w800)), const SizedBox(height: 3), Text('Compare smart alternatives', style: t(10, muted, FontWeight.w500))])), const Icon(Icons.chevron_right, color: green)]))),
      const SizedBox(height: 15),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Subtotal', style: t(10.5, muted, FontWeight.w600)), Text('\$${total.toStringAsFixed(2)}', style: t(13, darkGreen, FontWeight.w800))]),
    ]))),
    Padding(
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 14),
      child: PrimaryButton(
        label: 'Continue to fulfilment',
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FulfilmentPage(settings: widget.settings))),
      ),
    ),
  ]));
}

class CartItem extends StatelessWidget {
  final Product product; final int qty; final VoidCallback onMinus, onPlus;
  const CartItem({super.key, required this.product, required this.qty, required this.onMinus, required this.onPlus});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(7), decoration: BoxDecoration(color: white, border: Border.all(color: line), borderRadius: BorderRadius.circular(16)), child: Row(children: [SizedBox(width: 105, child: ProductArt(type: product.type, height: 55)), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(product.name, style: t(11, darkGreen, FontWeight.w800)), const SizedBox(height: 4), Text(product.price, style: t(10.5, green, FontWeight.w800))])), IconButton(onPressed: onMinus, icon: const Icon(Icons.remove, size: 14)), Text('$qty', style: t(10, darkGreen, FontWeight.w800)), IconButton(onPressed: onPlus, icon: const Icon(Icons.add, size: 14))]));
}

class SmartAlternativesPage extends StatefulWidget {
  final _SmartCartAppState settings;
  const SmartAlternativesPage({super.key, required this.settings});
  @override
  State<SmartAlternativesPage> createState() => _SmartAlternativesPageState();
}
class _SmartAlternativesPageState extends State<SmartAlternativesPage> {
  int selected = 0;
  @override
  Widget build(BuildContext context) => AppShell(child: Column(children: [
    Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(28, 10, 28, 18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      AppHeader(title: 'Smart alternatives', back: () => Navigator.pop(context)),
      Text('Keep your preferences while saving.', style: t(11, muted, FontWeight.w500)), const SizedBox(height: 15),
      Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: white, border: Border.all(color: line), borderRadius: BorderRadius.circular(17)), child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Current item', style: t(9, muted, FontWeight.w600)), const SizedBox(height: 5), Text('Premium cereal 500g', style: t(12, darkGreen, FontWeight.w800))])), Text('\$8.50', style: t(13, red, FontWeight.w800))])),
      const SizedBox(height: 18), SectionTitle(title: 'Suggested swaps'), const SizedBox(height: 8),
      AlternativeCard(number: '1', title: 'Store-brand cereal 500g', price: '\$5.20', save: 'save \$3.30', selected: selected==0, onTap: () => setState(() => selected=0)),
      const SizedBox(height: 8), AlternativeCard(number: '2', title: 'Oat clusters 450g', price: '\$6.40', save: 'save \$2.10', selected: selected==1, onTap: () => setState(() => selected=1)),
      const SizedBox(height: 10), InfoCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Preference check', style: t(10.5, darkGreen, FontWeight.w800)), const SizedBox(height: 4), Text('Dietary rules: passed • budget: improved', style: t(9.5, muted, FontWeight.w500))])),
    ]))),
    Padding(padding: const EdgeInsets.fromLTRB(28, 0, 28, 14), child: PrimaryButton(label: 'Use selected alternative', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FulfilmentPage(settings: widget.settings))))),
  ]));
}

class AlternativeCard extends StatelessWidget {
  final String number,title,price,save; final bool selected; final VoidCallback onTap;
  const AlternativeCard({super.key,required this.number,required this.title,required this.price,required this.save,required this.selected,required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: selected ? paleGreen : white, border: Border.all(color: selected ? const Color(0xFF78A981) : line), borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        CircleAvatar(radius: 15, backgroundColor: selected ? green : const Color(0xFFF4F5F1), child: Text(number, style: t(10, selected ? white : muted, FontWeight.w800))),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: t(11, darkGreen, FontWeight.w800)),
          const SizedBox(height: 3),
          Text('$price • $save', style: t(10, green, FontWeight.w800)),
          const SizedBox(height: 3),
          Text('Similar nutrition • no allergens', style: t(9, muted, FontWeight.w500)),
        ])),
      ]),
    ),
  );
}

class FulfilmentPage extends StatefulWidget {
  final _SmartCartAppState settings;
  const FulfilmentPage({super.key, required this.settings});
  @override
  State<FulfilmentPage> createState() => _FulfilmentPageState();
}
class _FulfilmentPageState extends State<FulfilmentPage> {
  bool delivery = true;
  @override
  Widget build(BuildContext context) => AppShell(child: Column(children: [
    Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(28, 10, 28, 18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      AppHeader(title: 'Delivery or pickup', back: () => Navigator.pop(context)), Text('Choose the most convenient option.', style: t(11, muted, FontWeight.w500)), const SizedBox(height: 15),
      SelectCard(selected: delivery, title: 'Home delivery', subtitle: 'Tomorrow • 6–8 PM', trailing: 'FREE', onTap: () => setState(() => delivery=true), letter:'D'),
      const SizedBox(height: 9), SelectCard(selected: !delivery, title: 'Click & Collect', subtitle: 'Ready in about 2 hours', trailing: 'FREE', onTap: () => setState(() => delivery=false), letter:'C'),
      const SizedBox(height: 22), SectionTitle(title: 'Order summary'), const SizedBox(height: 7),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('4 items',style:t(10,muted,FontWeight.w500)),Text('\$42.70',style:t(11,darkGreen,FontWeight.w800))]),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(delivery?'Delivery':'Pickup',style:t(10,muted,FontWeight.w500)),Text('\$0.00',style:t(11,darkGreen,FontWeight.w800))]),
      const SizedBox(height: 12), Container(padding:const EdgeInsets.all(13),decoration:BoxDecoration(color:white,border:Border.all(color:line),borderRadius:BorderRadius.circular(16)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Need an accessible ${delivery?'delivery':'pickup'}?',style:t(10.5,darkGreen,FontWeight.w800)),const SizedBox(height:4),Text('Add notes for the ${delivery?'driver':'store team'} on the next screen.',style:t(9.5,muted,FontWeight.w500))])),
    ]))),
    Padding(padding: const EdgeInsets.fromLTRB(28, 0, 28, 14), child: PrimaryButton(label: 'Choose address & time', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddressTimePage(settings: widget.settings, delivery: delivery))))),
  ]));
}

class SelectCard extends StatelessWidget { final bool selected; final String title,subtitle,trailing,letter; final VoidCallback onTap; const SelectCard({super.key,required this.selected,required this.title,required this.subtitle,required this.trailing,required this.onTap,required this.letter}); @override Widget build(BuildContext context)=>InkWell(onTap:onTap,borderRadius:BorderRadius.circular(17),child:Container(padding:const EdgeInsets.all(13),decoration:BoxDecoration(color:selected?paleGreen:white,border:Border.all(color:selected?const Color(0xFF78A981):line),borderRadius:BorderRadius.circular(17)),child:Row(children:[CircleAvatar(radius:16,backgroundColor:selected?green:const Color(0xFFF1F3EF),child:Text(letter,style:t(10,selected?white:muted,FontWeight.w800))),const SizedBox(width:11),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:t(11.5,darkGreen,FontWeight.w800)),const SizedBox(height:4),Text(subtitle,style:t(9.5,muted,FontWeight.w500))])),Column(crossAxisAlignment:CrossAxisAlignment.end,children:[Text(trailing,style:t(10,green,FontWeight.w800)),if(selected)Text('Selected',style:t(8.5,green,FontWeight.w700))])]))); }

class AddressTimePage extends StatefulWidget {
  final _SmartCartAppState settings;
  final bool delivery;
  const AddressTimePage({super.key, required this.settings, required this.delivery});
  @override
  State<AddressTimePage> createState() => _AddressTimePageState();
}

class _AddressTimePageState extends State<AddressTimePage> {
  int slot = 1;
  bool noContact = true;
  @override
  Widget build(BuildContext context) {
    return AppShell(
      child: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 10, 28, 18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AppHeader(title: 'Address & time', back: () => Navigator.pop(context)),
              Text('Delivery details', style: t(11, muted, FontWeight.w500)),
              const SizedBox(height: 14),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                SectionTitle(title: 'Address'),
                Text('Edit', style: t(10, green, FontWeight.w800)),
              ]),
              const SizedBox(height: 7),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(color: white, border: Border.all(color: line), borderRadius: BorderRadius.circular(16)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('12 Harbour Street', style: t(11, darkGreen, FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text('Sydney NSW 2000', style: t(9.5, muted, FontWeight.w500)),
                ]),
              ),
              const SizedBox(height: 18),
              SectionTitle(title: 'Available slots'),
              const SizedBox(height: 7),
              Wrap(spacing: 8, runSpacing: 8, children: [
                SlotCard(title: '5–6 PM', price: '\$4.00', selected: slot == 0, onTap: () => setState(() => slot = 0)),
                SlotCard(title: '6–8 PM', price: 'FREE', selected: slot == 1, onTap: () => setState(() => slot = 1)),
                SlotCard(title: '8–10 PM', price: 'FREE', selected: slot == 2, onTap: () => setState(() => slot = 2)),
              ]),
              const SizedBox(height: 18),
              SectionTitle(title: 'Delivery notes'),
              const SizedBox(height: 7),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
                decoration: BoxDecoration(color: white, border: Border.all(color: line), borderRadius: BorderRadius.circular(16)),
                child: Text('Leave at front door', style: t(10.5, muted, FontWeight.w500)),
              ),
              const SizedBox(height: 8),
              Row(children: [
                ChoiceChip(label: Text('No contact', style: t(9.5, noContact ? white : green, FontWeight.w700)), selected: noContact, onSelected: (_) => setState(() => noContact = true), selectedColor: green, backgroundColor: paleGreen, side: BorderSide.none),
                const SizedBox(width: 8),
                ChoiceChip(label: Text('Call on arrival', style: t(9.5, !noContact ? white : green, FontWeight.w700)), selected: !noContact, onSelected: (_) => setState(() => noContact = false), selectedColor: green, backgroundColor: paleGreen, side: BorderSide.none),
              ]),
            ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 28, 14),
          child: PrimaryButton(label: 'Continue to payment', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentPage(settings: widget.settings)))),
        ),
      ]),
    );
  }
}

class SlotCard extends StatelessWidget {
  final String title, price;
  final bool selected;
  final VoidCallback onTap;
  const SlotCard({super.key, required this.title, required this.price, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 155,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: selected ? paleGreen : white, border: Border.all(color: selected ? const Color(0xFF78A981) : line), borderRadius: BorderRadius.circular(16)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: t(11, darkGreen, FontWeight.w800)),
          const SizedBox(height: 4),
          Text(price, style: t(10, selected ? green : muted, FontWeight.w800)),
          if (selected) Align(alignment: Alignment.centerRight, child: Text('SELECTED', style: t(8, green, FontWeight.w800))),
        ]),
      ),
    );
  }
}

class PaymentPage extends StatefulWidget {
  final _SmartCartAppState settings;
  const PaymentPage({super.key, required this.settings});
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int method = 0;
  @override
  Widget build(BuildContext context) {
    return AppShell(
      child: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 10, 28, 18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AppHeader(title: 'Secure payment', back: () => Navigator.pop(context)),
              Text('Review before placing your order.', style: t(11, muted, FontWeight.w500)),
              const SizedBox(height: 15),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [SectionTitle(title: 'Payment method'), Text('Edit', style: t(10, green, FontWeight.w800))]),
              const SizedBox(height: 7),
              PaymentChoice(selected: method == 0, title: 'Visa •••• 4242', subtitle: 'Default card', icon: 'V', onTap: () => setState(() => method = 0)),
              const SizedBox(height: 8),
              PaymentChoice(selected: method == 1, title: 'PayPal', subtitle: 'Digital wallet', icon: 'P', onTap: () => setState(() => method = 1)),
              const SizedBox(height: 20),
              SectionTitle(title: 'Order summary'),
              const SizedBox(height: 7),
              SummaryRow(label: 'Items', value: '\$42.70'),
              SummaryRow(label: 'Delivery', value: '\$0.00'),
              SummaryRow(label: 'Rewards', value: '−\$10.00'),
              const Divider(height: 22),
              SummaryRow(label: 'Total', value: '\$32.70', bold: true),
              const SizedBox(height: 13),
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(color: white, border: Border.all(color: line), borderRadius: BorderRadius.circular(16)),
                child: Row(children: [
                  CircleAvatar(radius: 15, backgroundColor: paleGreen, child: Text('S', style: t(10, green, FontWeight.w800))),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Secure checkout', style: t(10.5, darkGreen, FontWeight.w800)), const SizedBox(height: 2), Text('Payment details are encrypted and protected.', style: t(9, muted, FontWeight.w500))])),
                ]),
              ),
            ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 28, 14),
          child: PrimaryButton(label: 'Place order • \$32.70', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderConfirmedPage(settings: widget.settings)))),
        ),
      ]),
    );
  }
}

class PaymentChoice extends StatelessWidget {
  final bool selected;
  final String title, subtitle, icon;
  final VoidCallback onTap;
  const PaymentChoice({super.key, required this.selected, required this.title, required this.subtitle, required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: selected ? paleGreen : white, border: Border.all(color: selected ? const Color(0xFF78A981) : line), borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        CircleAvatar(radius: 16, backgroundColor: selected ? green : const Color(0xFFF1F3EF), child: Text(icon, style: t(10, selected ? white : muted, FontWeight.w800))),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: t(11, darkGreen, FontWeight.w800)), Text(subtitle, style: t(9, muted, FontWeight.w500))])),
        if (selected) const Icon(Icons.check_circle, color: green, size: 19),
      ]),
    ),
  );
}

class SummaryRow extends StatelessWidget {
  final String label, value;
  final bool bold;
  const SummaryRow({super.key, required this.label, required this.value, this.bold = false});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: t(bold ? 12 : 10.5, bold ? darkGreen : muted, bold ? FontWeight.w800 : FontWeight.w500)),
      Text(value, style: t(bold ? 16 : 11, bold ? green : darkGreen, bold ? FontWeight.w800 : FontWeight.w700)),
    ]),
  );
}

class OrderConfirmedPage extends StatelessWidget {
  final _SmartCartAppState settings;
  const OrderConfirmedPage({super.key, required this.settings});
  @override
  Widget build(BuildContext context) {
    return AppShell(
      child: Column(children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(28, 34, 28, 34),
          decoration: const BoxDecoration(color: darkGreen, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(26), bottomRight: Radius.circular(26))),
          child: Column(children: [
            CircleAvatar(radius: 30, backgroundColor: green, child: const CircleAvatar(radius: 19, backgroundColor: Color(0xFFC7E99E), child: Icon(Icons.check, color: darkGreen))),
            const SizedBox(height: 16),
            Text('Order confirmed', style: t(23, white, FontWeight.w800)),
            const SizedBox(height: 4),
            Text('We’ll take it from here.', style: t(11, white, FontWeight.w500)),
          ]),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 20, 28, 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(color: white, border: Border.all(color: line), borderRadius: BorderRadius.circular(17)),
                child: Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Order #SC10482', style: t(11, darkGreen, FontWeight.w800)), const SizedBox(height: 5), Text('Tomorrow • 6–8 PM', style: t(9.5, muted, FontWeight.w500)), Text('4 items', style: t(9.5, muted, FontWeight.w500))])),
                  Text('\$32.70', style: t(14, green, FontWeight.w800)),
                ]),
              ),
              const SizedBox(height: 20),
              SectionTitle(title: 'What happens next?'),
              const SizedBox(height: 10),
              ...['Order received', 'Personal shopper picks items', 'Driver delivers your groceries'].asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(children: [
                  CircleAvatar(radius: 13, backgroundColor: e.key == 0 ? green : paleGreen, child: Text('${e.key + 1}', style: t(9, e.key == 0 ? white : green, FontWeight.w800))),
                  const SizedBox(width: 10),
                  Text(e.value, style: t(10.5, darkGreen, FontWeight.w700)),
                ]),
              )),
            ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 28, 14),
          child: PrimaryButton(label: 'Track order', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LiveTrackingPage(settings: settings)))),
        ),
      ]),
    );
  }
}

class LiveTrackingPage extends StatelessWidget {
  final _SmartCartAppState settings;
  const LiveTrackingPage({super.key, required this.settings});
  @override
  Widget build(BuildContext context) {
    return AppShell(
      child: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 10, 28, 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AppHeader(title: 'Live tracking', back: () => Navigator.pop(context)),
              Text('Order #SC10482', style: t(10.5, muted, FontWeight.w500)),
              const SizedBox(height: 13),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(color: darkGreen, borderRadius: BorderRadius.circular(17)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Arriving tomorrow', style: t(10, const Color(0xFFC7E99E), FontWeight.w700)),
                  const SizedBox(height: 5),
                  Text('6:00–8:00 PM', style: t(21, white, FontWeight.w800)),
                  Text('Picking groceries now', style: t(9.5, white, FontWeight.w500)),
                ]),
              ),
              const SizedBox(height: 20),
              SectionTitle(title: 'Progress'),
              const SizedBox(height: 10),
              ...['Order received', 'Picking items', 'Packed', 'Out for delivery', 'Delivered'].asMap().entries.map((e) => ProgressStep(index: e.key, title: e.value, done: e.key < 2, last: e.key == 4)),
              const SizedBox(height: 14),
              InfoCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Delivery note', style: t(10, darkGreen, FontWeight.w800)), const SizedBox(height: 4), Text('Leave at the front door', style: t(9.5, muted, FontWeight.w500))])),
            ]),
          ),
        ),
      ]),
    );
  }
}

class ProgressStep extends StatelessWidget {
  final int index;
  final String title;
  final bool done, last;
  const ProgressStep({super.key, required this.index, required this.title, required this.done, required this.last});
  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    SizedBox(width: 30, child: Column(children: [CircleAvatar(radius: 10, backgroundColor: done ? green : white, child: done ? const Icon(Icons.check, color: white, size: 12) : null), if (!last) Container(width: 2, height: 26, color: done ? green : line)])),
    Padding(padding: const EdgeInsets.only(top: 4), child: Text(title, style: t(10.5, done ? darkGreen : muted, done ? FontWeight.w800 : FontWeight.w500))),
  ]);
}

class OrdersPage extends StatelessWidget {
  final _SmartCartAppState settings;
  const OrdersPage({super.key, required this.settings});
  void nav(BuildContext context, int i) {
    final pages = [HomePage(settings: settings), SearchPage(settings: settings), SmartListPage(settings: settings), OrdersPage(settings: settings), ProfilePage(settings: settings)];
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => pages[i]));
  }
  @override
  Widget build(BuildContext context) {
    const dates = ['12 Aug', '05 Aug', '28 Jul', '21 Jul'];
    const totals = ['\$47.80', '\$62.10', '\$31.25', '\$54.30'];
    return AppShell(
      child: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 10, 28, 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Orders', style: t(23, darkGreen, FontWeight.w800)),
              const SizedBox(height: 3),
              Text('Track, reorder or view receipts.', style: t(11, muted, FontWeight.w500)),
              const SizedBox(height: 15),
              InfoCard(child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('CURRENT ORDER', style: t(8.5, green, FontWeight.w800)),
                  const SizedBox(height: 5),
                  Text('#SC10482 • Tomorrow', style: t(12, darkGreen, FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text('Picking items • 6–8 PM', style: t(9.5, muted, FontWeight.w500)),
                ])),
                TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LiveTrackingPage(settings: settings))), child: Text('Track ›', style: t(10, green, FontWeight.w800))),
              ])),
              const SizedBox(height: 20),
              SectionTitle(title: 'Previous orders'),
              const SizedBox(height: 8),
              ...List.generate(dates.length, (i) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: white, border: Border.all(color: line), borderRadius: BorderRadius.circular(16)),
                  child: Row(children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(dates[i], style: t(10.5, darkGreen, FontWeight.w800)), const SizedBox(height: 3), Text('View receipt • Reorder', style: t(9, muted, FontWeight.w500))])),
                    Text(totals[i], style: t(11, green, FontWeight.w800)),
                  ]),
                ),
              )),
            ]),
          ),
        ),
        BottomNav(selected: 3, onSelected: (i) => nav(context, i)),
      ]),
    );
  }
}

class ProfilePage extends StatefulWidget {
  final _SmartCartAppState settings;
  const ProfilePage({super.key, required this.settings});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void changeSetting(String key, bool value) {
    widget.settings.setState(() {
      if (key == 'large') widget.settings.largerText = value;
      if (key == 'contrast') widget.settings.highContrast = value;
      if (key == 'motion') widget.settings.reduceMotion = value;
      if (key == 'reader') widget.settings.screenReaderLabels = value;
    });
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return AppShell(
      child: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 10, 28, 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Profile', style: t(23, darkGreen, FontWeight.w800)),
              const SizedBox(height: 3),
              Text('Preferences, privacy and accessibility.', style: t(11, muted, FontWeight.w500)),
              const SizedBox(height: 17),
              Row(children: [
                const CircleAvatar(radius: 24, backgroundColor: green, child: Text('A', style: TextStyle(color: white, fontSize: 16, fontWeight: FontWeight.w800))),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Alex Morgan', style: t(13, darkGreen, FontWeight.w800)), const SizedBox(height: 3), Text('2,140 rewards points', style: t(10, green, FontWeight.w700))]),
              ]),
              const SizedBox(height: 22),
              SectionTitle(title: 'Accessibility'),
              const SizedBox(height: 8),
              SettingTile(title: 'Larger text', subtitle: 'Increase readable type size', value: widget.settings.largerText, onChanged: (v) => changeSetting('large', v)),
              SettingTile(title: 'High contrast', subtitle: 'Stronger text and surface contrast', value: widget.settings.highContrast, onChanged: (v) => changeSetting('contrast', v)),
              SettingTile(title: 'Reduce motion', subtitle: 'Minimise animated transitions', value: widget.settings.reduceMotion, onChanged: (v) => changeSetting('motion', v)),
              SettingTile(title: 'Screen reader labels', subtitle: 'Descriptive labels for controls', value: widget.settings.screenReaderLabels, onChanged: (v) => changeSetting('reader', v)),
              const SizedBox(height: 17),
              SectionTitle(title: 'Privacy & account'),
              const SizedBox(height: 8),
              AccountTile(title: 'Data & privacy', icon: Icons.privacy_tip_outlined),
              AccountTile(title: 'Delivery addresses', icon: Icons.location_on_outlined),
              AccountTile(title: 'Payment methods', icon: Icons.credit_card_outlined),
            ]),
          ),
        ),
        BottomNav(selected: 4, onSelected: (i) {
          final pages = [HomePage(settings: widget.settings), SearchPage(settings: widget.settings), SmartListPage(settings: widget.settings), OrdersPage(settings: widget.settings), ProfilePage(settings: widget.settings)];
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => pages[i]));
        }),
      ]),
    );
  }
}

class SettingTile extends StatelessWidget {
  final String title, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const SettingTile({super.key, required this.title, required this.subtitle, required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    decoration: BoxDecoration(color: white, border: Border.all(color: line), borderRadius: BorderRadius.circular(16)),
    child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: t(10.5, darkGreen, FontWeight.w800)), const SizedBox(height: 3), Text(subtitle, style: t(9, muted, FontWeight.w500))])),
      Switch(value: value, onChanged: onChanged, activeColor: green),
    ]),
  );
}

class AccountTile extends StatelessWidget {
  final String title;
  final IconData icon;
  const AccountTile({super.key, required this.title, required this.icon});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
    decoration: BoxDecoration(color: white, border: Border.all(color: line), borderRadius: BorderRadius.circular(16)),
    child: Row(children: [Icon(icon, size: 18, color: green), const SizedBox(width: 10), Expanded(child: Text(title, style: t(10.5, darkGreen, FontWeight.w800))), const Icon(Icons.chevron_right, size: 18, color: muted)]),
  );
}
