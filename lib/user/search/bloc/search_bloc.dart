import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final FirebaseFirestore firestore;

  SearchBloc({required this.firestore}) : super(SearchInitial()) {
    on<SearchQueryChanged>((event, emit) async {
      print('Event received: ${event.query}'); // Debug print
      emit(SearchLoading());
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('products')
            .where('name', isGreaterThanOrEqualTo: event.query)
            .where('name', isLessThanOrEqualTo: '${event.query}\uf8ff')
            .get();

        print('Documents found: ${querySnapshot.docs.length}'); // Debug print
        print(
            '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');

        if (querySnapshot.docs.isEmpty) {
          emit(SearchNoResults());
        } else {
          final products = querySnapshot.docs.map((doc) {
            return {
              'name': doc['name'],
              'price': doc['price'],
              'desc': doc['desc'],
              'imgUrl': doc['imgUrl'],
              'quantity': doc['quantity'],
              'unit': doc['unit'],
            };
          }).toList();
          emit(SearchLoaded(products: products));
        }
      } catch (e) {
        print('Error: $e'); // Debug print
        emit(SearchError(message: e.toString()));
      }
    });
  }
}
