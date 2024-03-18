import 'package:app_admin_pizzeria/providers/page_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PageProvider>(context, listen: false);
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 202, 202, 202),
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/pizzeria.png"),
          ),
          DrawerListTile(
            title: "Ordini",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {
              provider.changePage(0);
            },
          ),
          DrawerListTile(
            title: "Mappa",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {
              provider.changePage(1);
            },
          ),
          DrawerListTile(
            title: "Menu",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {
              provider.changePage(2);
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.title,
    required this.svgSrc,
    required this.press,
  });

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
