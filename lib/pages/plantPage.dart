import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:plant_disease_app/config/constants.dart';
import 'package:plant_disease_app/widgets/widgets.dart';
import 'package:intl/intl.dart';

class PlantPage extends StatefulWidget {
  const PlantPage({Key? key}) : super(key: key);

  @override
  _PlantPageState createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: kDefaultPadding / 2, vertical: kDefaultPadding),
        child: Column(children: [
          CustomTabBar(
            tabController: _tabController,
            tabTexts: ['My Plants', 'History'],
          ),
          Expanded(
            child: TabBarView(controller: _tabController, children: [
              Column(
                children: [
                  SearchBar(),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(kDefaultBorderRaduis),
                          color: Theme.of(context).colorScheme.secondary),
                      padding: EdgeInsets.all(kDefaultPadding / 2),
                      child: ListPlants(plantList: [
                        PlantView(
                            imageUrl: 'assets/images/image_1.jpg',
                            species: 'Tomato',
                            condition: 'Healthy',
                            date: DateTime(2021, 4, 5)),
                        ...List.generate(
                            10,
                            (index) => PlantView(
                                imageUrl: 'assets/images/image_2.jpg',
                                species: 'Tomato',
                                condition: 'Cancer',
                                date: DateTime(2020, 12, 1)))
                      ]),
                    ),
                  ),
                ],
              ),
              Center(child: Text('4'))
            ]),
          ),
        ]));
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      margin: EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: Row(children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(kDefaultBorderRaduis * 2),
            ),
            child: TextField(
              decoration: InputDecoration(
                  hintText: "Search", prefixIcon: Icon(Iconsax.search_normal4)),
            ),
          ),
        ),
        SizedBox(width: 20),
        DropDownFilter(
            options: [FilterItem(text: 'Date'), FilterItem(text: 'Alphabet')])
      ]),
    );
  }
}

class ListPlants extends StatefulWidget {
  const ListPlants({Key? key, required this.plantList}) : super(key: key);
  final List<PlantView> plantList;
  @override
  _ListPlantsState createState() => _ListPlantsState();
}

class _ListPlantsState extends State<ListPlants> {
  @override
  Widget build(BuildContext context) {
    DateFormat _format = DateFormat.yMMMd();
    return ListView.separated(
      itemCount: widget.plantList.length,
      separatorBuilder: (context, index) => SizedBox(
        height: 15,
      ),
      itemBuilder: (context, index) {
        PlantView _plantCard = widget.plantList[index];
        return Container(
          padding: EdgeInsets.all(kDefaultPadding * 0.6),
          child: Stack(children: [
            Row(
              children: [
                Container(
                  height: 130, //140
                  width: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kDefaultBorderRaduis),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(_plantCard.imageUrl),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  height: 130,
                  padding:
                      EdgeInsets.symmetric(vertical: kDefaultPadding * 0.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _plantCard.species,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                            vertical: kDefaultPadding * 0.2,
                            horizontal: kDefaultPadding * 0.5),
                        child: Text(
                          _plantCard.condition,
                          style: TextStyle(
                              fontSize: 12,
                              color: _plantCard.condition == 'Healthy'
                                  ? Theme.of(context).accentColor
                                  : Theme.of(context).colorScheme.error,
                              fontWeight: FontWeight.bold),
                        ),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(kDefaultBorderRaduis),
                            color: (_plantCard.condition == 'Healthy'
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).colorScheme.error)
                                .withOpacity(0.1)),
                      ),
                      Spacer(),
                      Text(_format.format(_plantCard.date)),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
                right: 0,
                top: kDefaultPadding * 0.3,
                child: Container(
                    height: 30,
                    width: 30,
                    child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                            splashColor: Colors.transparent,
                            borderRadius:
                                BorderRadius.circular(kDefaultBorderRaduis / 2),
                            onTap: () {},
                            child: Icon(
                              Iconsax.more_24,
                            )))))
          ]),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .secondaryVariant
                      .withOpacity(0.23),
                  blurRadius: 6.0,
                ),
              ],
              borderRadius: BorderRadius.circular(kDefaultBorderRaduis),
              color: Theme.of(context).backgroundColor),
        );
      },
    );
  }
}

class PlantView {
  final String imageUrl;
  final String species;
  final String condition;
  final DateTime date;
  const PlantView(
      {required this.imageUrl,
      required this.species,
      required this.condition,
      required this.date});
}
