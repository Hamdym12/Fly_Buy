import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Shop-App/Shared/Constants/constants.dart';
import 'package:shop_app/Shop-App/models/search_Model.dart';
import 'package:shop_app/Shop-App/network/end_Points.dart';
import 'package:shop_app/Shop-App/network/remote/dio_helper.dart';
import 'package:shop_app/Shop-App/search/Cubit/States.dart';

class SearchCubit extends Cubit<SearchStates>{
  SearchCubit() : super(SearchInitialState());
  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? searchModel;

  void search(String text){
    emit(SearchLoadingState());
    DioHelper.postData(
        url: SEARCH,
        data: {
          'text':text
        },
      token: token,
    ).then((value){
      searchModel = SearchModel.fromJson(value.data);
      emit(SearchSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(SearchErrorState());
    });

  }
}