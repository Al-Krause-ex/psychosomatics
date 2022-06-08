import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:psychosomatics/constants/hexcolor_str.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: HexColor(primaryHexColor),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 15.0,
            bottom: 40.0,
            left: 20.0,
            right: 20.0,
          ),
          child: _isPortrait
              ? _buildContent(context, _isPortrait)
              : SingleChildScrollView(
                  child: _buildContent(context, _isPortrait)),
        ),
      ),
    );
  }

  Widget _buildContent(context, isPortrait) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _appBar(context),
        _buildSection(
            'Стоимость подписки', 'Неделя бесплатно\nДалее N руб / мес'),
        _buildDivider(),
        _buildSection('Преимущества',
            'Преимущество №1\nПреимущество №2\nПреимущество №3'),
        if (isPortrait) const Spacer(),
        if (!isPortrait) const SizedBox(height: 50.0),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: Size(MediaQuery.of(context).size.width, 40.0),
            primary: HexColor(elevatedButtonHexColor),
          ),
          onPressed: () {},
          child: const Text('Приобрести'),
        ),
      ],
    );
  }

  Widget _appBar(context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios_outlined,
                color: Colors.white,
                size: 25.0,
              ),
              splashRadius: 25.0,
            ),
            const Center(
              child: Text(
                'Подписка',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            IconButton(
              onPressed: null,
              icon: Icon(
                Icons.filter_list,
                color: HexColor(primaryHexColor),
                size: 30.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 5.0,
        top: 10.0,
        bottom: 10.0,
      ),
      child: Divider(
        color: HexColor('#E1F6FB'),
      ),
    );
  }
}
