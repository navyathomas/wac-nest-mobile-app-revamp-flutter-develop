import 'package:async/async.dart' show Result;
import 'package:flutter/cupertino.dart';
import 'package:nest_matrimony/common/constants.dart';
import 'package:nest_matrimony/models/testimonials_response_model.dart';
import 'package:nest_matrimony/services/base_provider_class.dart';

import '../services/http_requests.dart';

class TestimonialsProvider extends ChangeNotifier with BaseProviderClass {
  List<TestimonialUserData> testimonialsList = [];
  int pageLength = 0;
  Future<void> getTestimonials() async {
    updateLoaderState(LoaderState.loading);
    Result res = await serviceConfig.getTestimonials();
    if (res.isValue) {
      TestimonialsResponseModel testimonialsResponseModel = res.asValue!.value;
      testimonialsList = testimonialsResponseModel.data?.original?.data ?? [];
      pageLength = testimonialsList.length;
      //pageLength = testimonialsList.length > 5 ? 5 : testimonialsList.length;
      updateLoaderState(LoaderState.loaded);
    } else {
      updateLoaderState(fetchError(res.asError!.error as Exceptions));
    }
    notifyListeners();
  }

  @override
  void updateLoaderState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}
