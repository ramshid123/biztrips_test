import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persons/core/theme/palette.dart';
import 'package:persons/core/widgets/common.dart';
import 'package:persons/features/persons/domain/entities/person_entity.dart';
import 'package:persons/features/persons/presentation/cubits/selected_filter_cubit.dart';
import 'package:persons/features/persons/presentation/person_bloc/persons_bloc.dart';
import 'package:persons/features/persons/presentation/view/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  final scrollController = ScrollController();

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    context.read<PersonsBloc>().add(PersonsEventFetchData());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final filterKeys = [
      'All',
      'Male',
      'Female',
      'Adult',
      'Children',
      'Old',
      'Citizen',
      'Foriegn',
    ];

    return Scaffold(
      backgroundColor: ColorConstants.bg,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: BlocBuilder<PersonsBloc, PersonsState>(
        builder: (context, state) {
          if (state is PersonsStateLoading || state is PersonsInitial) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: ColorConstants.black,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const CircularProgressIndicator(
                  color: ColorConstants.white,
                ),
              ),
            );
          } else {
            List<PersonEntity> persons = [];
            if (state is PersonsStatePersons) {
              persons = state.persons;
            }
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                NotificationListener<ScrollUpdateNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollController.position.userScrollDirection ==
                        ScrollDirection.reverse) {
                      animationController.forward();
                    } else {
                      if (scrollController.position.userScrollDirection ==
                          ScrollDirection.forward) {
                        animationController.reverse();
                      }
                    }
                    return true;
                  },
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverAppBar(
                        backgroundColor: ColorConstants.bg,
                        shadowColor: ColorConstants.black.withOpacity(0.1),
                        surfaceTintColor: ColorConstants.bg,
                        floating: true,
                        stretch: true,
                        toolbarHeight: 150,
                        expandedHeight: 150,
                        pinned: false,
                        snap: true,
                        flexibleSpace: SafeArea(
                          child: Column(
                            children: [
                              kHeight(10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ColorConstants.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF000000)
                                                .withOpacity(0.1),
                                            offset: const Offset(0, 0),
                                            blurRadius: 17,
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.menu,
                                        size: 25,
                                        color: ColorConstants.black,
                                      ),
                                    ),
                                    kText(
                                      text: 'Users',
                                      fontSize: 30,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ColorConstants.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF000000)
                                                .withOpacity(0.1),
                                            offset: const Offset(0, 0),
                                            blurRadius: 17,
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.search,
                                        size: 25,
                                        color: ColorConstants.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              kHeight(20),
                              BlocBuilder<SelectedFilterCubit, int>(
                                builder: (context, filterIndex) {
                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        for (int i = 0;
                                            i < filterKeys.length;
                                            i++)
                                          GestureDetector(
                                            onTap: () => context
                                                .read<SelectedFilterCubit>()
                                                .changeFilter(i),
                                            child: Container(
                                              margin: const EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 25, vertical: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: filterIndex == i
                                                    ? ColorConstants.black
                                                    : Colors.transparent,
                                                border: Border.all(
                                                  color: ColorConstants.black,
                                                ),
                                              ),
                                              child: kText(
                                                text: filterKeys[i],
                                                color: filterIndex == i
                                                    ? ColorConstants.white
                                                    : ColorConstants.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      persons.isEmpty
                          ? SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 150),
                                child: Center(
                                  child: kText(
                                    text: 'No user data!',
                                    color:
                                        ColorConstants.black.withOpacity(0.3),
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                          : SliverGrid(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return HomePageWidgets.userCard(
                                    context: context,
                                    personEntity: persons[index],
                                  );
                                },
                                childCount: persons.length,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                            ),
                      const SliverPadding(padding: EdgeInsets.symmetric(vertical: 50))
                    ],
                  ),
                ),
                AddButton(
                  animationController: animationController,
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
