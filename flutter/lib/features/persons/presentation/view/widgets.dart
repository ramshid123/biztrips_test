import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persons/core/theme/palette.dart';
import 'package:persons/core/widgets/common.dart';
import 'package:persons/features/persons/domain/entities/person_entity.dart';
import 'package:persons/features/persons/presentation/person_bloc/persons_bloc.dart';

class HomePageWidgets {
  static Widget _userInfoCard(
      {required BuildContext context, required PersonEntity person}) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              decoration: BoxDecoration(
                color: ColorConstants.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  kText(
                    text: 'Name',
                    fontSize: 14,
                    color: ColorConstants.black.withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                  ),
                  kHeight(5),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: ColorConstants.black.withOpacity(0.3),
                      ),
                    ),
                    child: kText(
                      text: person.name,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  kHeight(25),
                  kText(
                    text: 'Age',
                    fontSize: 14,
                    color: ColorConstants.black.withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                  ),
                  kHeight(5),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: ColorConstants.black.withOpacity(0.3),
                      ),
                    ),
                    child: kText(
                      text: person.age.toString(),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  kHeight(35),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ColorConstants.black,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: kText(
                          text: 'Done',
                          color: ColorConstants.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  static Widget userCard({
    required PersonEntity personEntity,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColorConstants.card,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.1),
            offset: const Offset(0, 0),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 23,
                backgroundColor: ColorConstants.white,
                child: Icon(
                  Icons.person,
                  color: ColorConstants.black,
                ),
              ),
              kWidth(10),
              Expanded(
                child: kText(
                  text: personEntity.name,
                  fontSize: 18,
                  maxLines: 2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          kHeight(15),
          kText(
            text: '${personEntity.age} years old.',
            fontSize: 15,
            color: ColorConstants.black.withOpacity(0.6),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    await showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return _userInfoCard(
                            context: context, person: personEntity);
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: ColorConstants.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF000000).withOpacity(0.1),
                          offset: const Offset(0, 0),
                          blurRadius: 17,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: kText(
                        text: 'View',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
              kWidth(10),
              GestureDetector(
                onTap: () async {
                  context
                      .read<PersonsBloc>()
                      .add(PersonsEventDeletePerson(personEntity.id));

                  context.read<PersonsBloc>().add(PersonsEventFetchData());
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: ColorConstants.white,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF000000).withOpacity(0.1),
                        offset: const Offset(0, 0),
                        blurRadius: 17,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AddButton extends StatefulWidget {
  final AnimationController animationController;
  const AddButton({super.key, required this.animationController});

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  late Animation animation;

  @override
  void initState() {
    animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: widget.animationController, curve: Curves.easeInOutBack));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          return Transform.translate(
            offset: Offset(0, 100.0 * animation.value),
            child: GestureDetector(
              onTap: () async {
                await showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => const AddPersonBottomSheet(),
                );

                if (context.mounted) {
                  context.read<PersonsBloc>().add(PersonsEventFetchData());
                }
              },
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: ColorConstants.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    kText(
                      text: 'Add',
                      color: ColorConstants.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    kWidth(10),
                    const Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class AddPersonBottomSheet extends StatefulWidget {
  const AddPersonBottomSheet({super.key});

  @override
  State<AddPersonBottomSheet> createState() => _AddPersonBottomSheetState();
}

class _AddPersonBottomSheetState extends State<AddPersonBottomSheet> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              decoration: BoxDecoration(
                color: ColorConstants.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    textForm(
                      hintText: 'Name *',
                      innerText: 'What is the name of the person?',
                      textController: nameController,
                    ),
                    kHeight(25),
                    textForm(
                      hintText: 'Age *',
                      innerText: 'What is the age of the person?',
                      textController: ageController,
                      isNum: true,
                    ),
                    kHeight(35),
                    GestureDetector(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          context.read<PersonsBloc>().add(PersonsEventAddPerson(
                              name: nameController.text,
                              age: int.parse(ageController.text)));
                          Navigator.pop(context);
                          formKey.currentState!.reset();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: ColorConstants.black,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: kText(
                            text: 'Submit',
                            color: ColorConstants.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget textForm({
    required String hintText,
    required String innerText,
    required TextEditingController textController,
    bool isNum = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        kText(
          text: hintText,
        ),
        kHeight(2),
        TextFormField(
          controller: textController,
          inputFormatters: isNum
              ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
              : [],
          keyboardType: isNum ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: innerText,
            hintStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorConstants.black.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorConstants.black.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorConstants.black.withOpacity(0.3),
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '';
            }
            return null;
          },
        ),
      ],
    );
  }
}
