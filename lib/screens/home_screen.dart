import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loopez/components/ad_item.dart';
import 'package:flutter_loopez/components/category_item_widget.dart';
import 'package:flutter_loopez/constants.dart';
import 'package:flutter_loopez/model/ads.dart';
import 'package:flutter_loopez/model/categories.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Ads ads = Provider.of<Ads>(context);
    print('Ads received on homescreen: ${ads.ads.length}');
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_pin),
                  SizedBox(width: 10),
                  Text(ads.getAddress.locality ?? 'Unknown City'),
                  Text(' , '),
                  Text(ads.getAddress.adminArea ?? 'Unknown State'),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 60,
                child: Center(
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search anything!',
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Browse Categories'),
                        TextButton(
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(50, 30),
                                alignment: Alignment.centerLeft),
                            onPressed: _seeAllClicked,
                            child: Text('See All')),
                      ],
                    ),
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 15),
                        itemBuilder: (context, index) => CategoryItem(
                          backgroundColor:
                              MAIN_CATEGORIS[index].backgroundColor,
                          iconAddress: MAIN_CATEGORIS[index].iconAddress,
                          name: MAIN_CATEGORIS[index].name,
                          onClick: () {},
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: MAIN_CATEGORIS.length,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return AdItem(
                        ad: ads.ads[index],
                      );
                    },
                    itemCount: ads.ads.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(
                      height: 10,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _seeAllClicked() {}
}
