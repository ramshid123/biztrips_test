
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

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController animationController;

  final scrollController = ScrollController();

  ValueNotifier isSearching = ValueNotifier(false);

  ValueNotifier filterValuesCount = ValueNotifier(0);

  final searchFormKey = GlobalKey<FormState>();
  final searchTextController = TextEditingController();
  final fromTextController = TextEditingController();
  final toTextController = TextEditingController();

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    context.read<PersonsBloc>().add(PersonsEventFetchData());

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
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

    return ValueListenableBuilder(
        valueListenable: isSearching,
        builder: (context, value, _) {
          return PopScope(
            canPop: !isSearching.value,
            onPopInvokedWithResult: (didPop, result) {
              isSearching.value = false;
            },
            child: Scaffold(
              backgroundColor: ColorConstants.bg,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
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
                              if (scrollController
                                      .position.userScrollDirection ==
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
                                shadowColor:
                                    ColorConstants.black.withOpacity(0.1),
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
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
                                                    color:
                                                        const Color(0xFF000000)
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
                                            GestureDetector(
                                              onTap: () =>
                                                  isSearching.value = true,
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color:
                                                          ColorConstants.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: const Color(
                                                                  0xFF000000)
                                                              .withOpacity(0.1),
                                                          offset: const Offset(
                                                              0, 0),
                                                          blurRadius: 17,
                                                          spreadRadius: 0,
                                                        ),
                                                      ],
                                                    ),
                                                    child: const Icon(
                                                      Icons.search,
                                                      size: 25,
                                                      color:
                                                          ColorConstants.black,
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: filterValuesCount
                                                            .value >
                                                        0,
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(6),
                                                      decoration: const BoxDecoration(
                                                        color: Colors.red,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: kText(
                                                        text: filterValuesCount
                                                            .value
                                                            .toString(),
                                                        color: ColorConstants
                                                            .white,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
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
                                                        .read<
                                                            SelectedFilterCubit>()
                                                        .changeFilter(i),
                                                    child: Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 25,
                                                          vertical: 10),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        color: filterIndex == i
                                                            ? ColorConstants
                                                                .black
                                                            : Colors
                                                                .transparent,
                                                        border: Border.all(
                                                          color: ColorConstants
                                                              .black,
                                                        ),
                                                      ),
                                                      child: kText(
                                                        text: filterKeys[i],
                                                        color: filterIndex == i
                                                            ? ColorConstants
                                                                .white
                                                            : ColorConstants
                                                                .black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                        padding:
                                            const EdgeInsets.only(top: 150),
                                        child: Center(
                                          child: kText(
                                            text: 'No user data!',
                                            color: ColorConstants.black
                                                .withOpacity(0.3),
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
                              const SliverPadding(
                                  padding: EdgeInsets.symmetric(vertical: 50))
                            ],
                          ),
                        ),
                        AddButton(
                          animationController: animationController,
                        ),
                        Visibility(
                          visible: isSearching.value,
                          child: GestureDetector(
                            onTap: () => isSearching.value = false,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.black.withOpacity(0.7),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 50),
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: ColorConstants.bg,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        HomePageWidgets.textForm(
                                          hintText: '',
                                          innerText: 'Search for a name',
                                          textController: searchTextController,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: HomePageWidgets.textForm(
                                                hintText: '',
                                                innerText: 'From',
                                                isNum: true,
                                                textController:
                                                    fromTextController,
                                              ),
                                            ),
                                            kWidth(25),
                                            Container(
                                              margin: const EdgeInsets.only(top: 20),
                                              height: 1,
                                              width: 10,
                                              color: ColorConstants.black,
                                            ),
                                            kWidth(25),
                                            Expanded(
                                              child: HomePageWidgets.textForm(
                                                hintText: '',
                                                innerText: 'To',
                                                isNum: true,
                                                textController:
                                                    toTextController,
                                              ),
                                            ),
                                          ],
                                        ),
                                        kHeight(30),
                                        GestureDetector(
                                          onTap: () {
                                            isSearching.value = false;

                                            filterValuesCount.value = 0;

                                            if (searchTextController
                                                .text.isNotEmpty) {
                                              filterValuesCount.value++;
                                            }

                                            if (fromTextController
                                                .text.isNotEmpty) {
                                              filterValuesCount.value++;
                                            }

                                            if (toTextController
                                                .text.isNotEmpty) {
                                              filterValuesCount.value++;
                                            }

                                            context
                                                .read<PersonsBloc>()
                                                .add(PersonsEventFetchData(
                                                  name: searchTextController
                                                          .text.isEmpty
                                                      ? null
                                                      : searchTextController
                                                          .text,
                                                  fromAge: fromTextController
                                                          .text.isEmpty
                                                      ? null
                                                      : int.parse(
                                                          fromTextController
                                                              .text),
                                                  toAge: toTextController
                                                          .text.isEmpty
                                                      ? null
                                                      : int.parse(
                                                          toTextController
                                                              .text),
                                                ));
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            decoration: BoxDecoration(
                                              color: ColorConstants.black,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Center(
                                              child: kText(
                                                text: 'Search',
                                                color: ColorConstants.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        kHeight(20),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: GestureDetector(
                                            onTap: () {
                                              isSearching.value = false;
                                              filterValuesCount.value = 0;
                                              searchTextController.clear();
                                              fromTextController.clear();
                                              toTextController.clear();
                                              context
                                                  .read<PersonsBloc>()
                                                  .add(PersonsEventFetchData());
                                            },
                                            child: Container(
                                              child: kText(
                                                text: 'Clear all',
                                                color: Colors.blue,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          );
        });
  }
}
