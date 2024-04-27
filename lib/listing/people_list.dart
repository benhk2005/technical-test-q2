import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moovup_flutter/bloc/main_bloc.dart';
import 'package:moovup_flutter/model/person.dart';

class PeopleList extends StatelessWidget {
  const PeopleList({super.key});

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
            ),
          );
        }
      },
    );
  }
}

class PersonCard extends StatelessWidget {
  final Person person;
  const PersonCard({
    super.key,
    required this.person,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
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
          SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.id,
                ),
                Text(
                  person.getName(),
                ),
                Text(
                  person.email ?? "",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
