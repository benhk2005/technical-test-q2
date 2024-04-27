import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moovup_flutter/bloc/main_bloc.dart';
import 'package:moovup_flutter/map/map_view.dart';
import 'package:moovup_flutter/model/person.dart';

class PeopleList extends StatelessWidget {
  const PeopleList({super.key});

  void handlePersonClick(BuildContext context, Person person) {
    if (!person.shouldShowInMap()) {
      showLocationIncorrectDialog(context);
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MapView(
        person: person,
      ),
    ));
  }

  void showLocationIncorrectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Unable to show in map"),
        content: const Text("Incorrect location data"),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainBlocState>(
      bloc: context.read(),
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: state.people.length,
            itemBuilder: (context, index) => PersonCard(
              person: state.people[index],
              onTapCallback: (person) => {handlePersonClick(context, person)},
            ),
          );
        }
      },
    );
  }
}

class PersonCard extends StatelessWidget {
  final Person person;
  final Function(Person person) onTapCallback;
  const PersonCard({
    super.key,
    required this.person,
    required this.onTapCallback,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapCallback(person),
      child: Container(
        decoration: const BoxDecoration(),
        padding: const EdgeInsets.all(
          16.0,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 48.0,
              height: 48.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  24.0,
                ),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: person.picture ?? "",
                  placeholder: (context, url) => Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    person.getName(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
