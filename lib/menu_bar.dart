import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tamannaretail/funcCreateDatabase.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: MenuBar(
                children: <Widget>[
                  SubmenuButton(
                    menuChildren: <Widget>[
                      MenuItemButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/FrmCountryMaster');
                        },
                        shortcut: const SingleActivator(LogicalKeyboardKey.keyC,
                            alt: true),
                        child: const MenuAcceleratorLabel('&COUNTRY MASTER'),
                      ),
                      MenuItemButton(
                        onPressed: () {},
                        shortcut: const SingleActivator(LogicalKeyboardKey.keyS,
                            alt: true),
                        child: const MenuAcceleratorLabel('&STATE MASTER'),
                      ),
                      MenuItemButton(
                        onPressed: () {},
                        shortcut: const SingleActivator(LogicalKeyboardKey.keyY,
                            alt: true),
                        child: const MenuAcceleratorLabel('CIT&Y MASTER'),
                      ),
                    ],
                    child: const MenuAcceleratorLabel('&MASTERS'),
                  ),
                  SubmenuButton(
                    menuChildren: <Widget>[
                      MenuItemButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/FrmCompanyList');
                        },
                        shortcut: const SingleActivator(LogicalKeyboardKey.keyC,
                            alt: true),
                        child: const MenuAcceleratorLabel('&CHANGE COMPANY'),
                      ),
                      MenuItemButton(
                        onPressed: () {
                          createYear(context, '');
                        },
                        shortcut: const SingleActivator(LogicalKeyboardKey.keyY,
                            alt: true),
                        child: const MenuAcceleratorLabel('CREATE YEAR'),
                      ),
                      MenuItemButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed("/FrmThemeColor");
                        },
                        shortcut: const SingleActivator(LogicalKeyboardKey.keyY,
                            alt: true),
                        child: const MenuAcceleratorLabel('THEME SETTINGS'),
                      ),
                    ],
                    child: const MenuAcceleratorLabel('&UTILITIES'),
                  ),
                  SubmenuButton(
                    menuChildren: <Widget>[
                      SubmenuButton(menuChildren: <Widget>[
                        MenuItemButton(
                          shortcut: const SingleActivator(
                              LogicalKeyboardKey.keyQ,
                              alt: true),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Quit!'),
                              ),
                            );
                          },
                          child: const MenuAcceleratorLabel('&Quit'),
                        ),
                      ], child: const MenuAcceleratorLabel('&ts'))
                    ],
                    child: const MenuAcceleratorLabel('&View'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
