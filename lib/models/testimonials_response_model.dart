class TestimonialsResponseModel {
  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  TestimonialsResponseModel({status, statusCode, message, data});

  TestimonialsResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> datas = <String, dynamic>{};
    datas['status'] = status;
    datas['status_code'] = statusCode;
    datas['message'] = message;
    datas['data'] = data?.toJson();
    return datas;
  }
}

class Data {
  Original? original;
  var exception;

  Data({original, exception});

  Data.fromJson(Map<String, dynamic> json) {
    original =
        json['original'] != null ? Original.fromJson(json['original']) : null;
    exception = json['exception'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (original != null) {
      data['original'] = original!.toJson();
    }
    data['exception'] = exception;
    return data;
  }
}

class Original {
  int? draw;
  int? recordsTotal;
  int? recordsFiltered;
  List<TestimonialUserData>? data;
  bool? status;
  int? lastPageNumber;
  String? currentPage;
  String? itemPerPage;
  Input? input;

  Original(
      {draw,
      recordsTotal,
      recordsFiltered,
      data,
      status,
      lastPageNumber,
      currentPage,
      itemPerPage,
      input});

  Original.fromJson(Map<String, dynamic> json) {
    draw = json['draw'];
    recordsTotal = json['recordsTotal'];
    recordsFiltered = json['recordsFiltered'];
    if (json['data'] != null) {
      data = <TestimonialUserData>[];
      json['data'].forEach((v) {
        data!.add(TestimonialUserData.fromJson(v));
      });
    }
    status = json['status'];
    lastPageNumber = json['last_page_number'];
    currentPage = json['current_page'];
    itemPerPage = json['Item_per_page'];
    input = json['input'] != null ? Input.fromJson(json['input']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> datas = <String, dynamic>{};
    datas['draw'] = draw;
    datas['recordsTotal'] = recordsTotal;
    datas['recordsFiltered'] = recordsFiltered;
    if (data != null) {
      datas['data'] = data!.map((v) => v.toJson()).toList();
    }
    datas['status'] = status;
    datas['last_page_number'] = lastPageNumber;
    datas['current_page'] = currentPage;
    datas['Item_per_page'] = itemPerPage;
    if (input != null) {
      datas['input'] = input!.toJson();
    }
    return datas;
  }
}

class TestimonialUserData {
  int? id;
  String? groomName;
  String? brideName;
  String? thinkAbout;
  String? dateOfMarriage;
  String? feedback;
  String? imageFile;
  int? isApproved;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  TestimonialUserData(
      {id,
      groomName,
      brideName,
      thinkAbout,
      dateOfMarriage,
      feedback,
      imageFile,
      isApproved,
      deletedAt,
      createdAt,
      updatedAt});

  TestimonialUserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groomName = json['groom_name'];
    brideName = json['bride_name'];
    thinkAbout = json['think_about'];
    dateOfMarriage = json['date_of_marriage'];
    feedback = json['feedback'];
    imageFile = json['image_file'];
    isApproved = json['is_approved'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['groom_name'] = groomName;
    data['bride_name'] = brideName;
    data['think_about'] = thinkAbout;
    data['date_of_marriage'] = dateOfMarriage;
    data['feedback'] = feedback;
    data['image_file'] = imageFile;
    data['is_approved'] = isApproved;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Input {
  String? length;
  String? page;

  Input({length, page});

  Input.fromJson(Map<String, dynamic> json) {
    length = json['length'];
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['length'] = length;
    data['page'] = page;
    return data;
  }
}
