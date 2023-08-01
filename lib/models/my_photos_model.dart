import 'dart:convert';

MyPhotosModel myPhotosModelFromJson(String str) => MyPhotosModel.fromJson(json.decode(str));

String myPhotosModelToJson(MyPhotosModel data) => json.encode(data.toJson());

class MyPhotosModel {
    MyPhotosModel({
        this.status,
        this.statusCode,
        this.message,
        this.data,
    });

    bool? status;
    int ?statusCode;
    String ?message;
    Data? data;

    factory MyPhotosModel.fromJson(Map<String, dynamic> json) => MyPhotosModel(
        status: json["status"] == null ? null : json["status"],
        statusCode: json["status_code"] == null ? null : json["status_code"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "status_code": statusCode == null ? null : statusCode,
        "message": message == null ? null : message,
        "data": data == null ? null : data?.toJson(),
    };
}

class Data {
    Data({
        this.headers,
        this.original,
        this.exception,
    });

    Headers ?headers;
    Original? original;
    dynamic exception;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        headers: json["headers"] == null ? null : Headers.fromJson(json["headers"]),
        original: json["original"] == null ? null : Original.fromJson(json["original"]),
        exception: json["exception"],
    );

    Map<String, dynamic> toJson() => {
        "headers": headers == null ? null : headers?.toJson(),
        "original": original == null ? null : original?.toJson(),
        "exception": exception,
    };
}

class Headers {
    Headers();

    factory Headers.fromJson(Map<String, dynamic> json) => Headers(
    );

    Map<String, dynamic> toJson() => {
    };
}

class Original {
    Original({
        this.draw,
        this.recordsTotal,
        this.recordsFiltered,
        this.data,
        this.status,
        this.lastPageNumber,
        this.currentPage,
        this.itemPerPage,
        // this.input,
    });

    int? draw;
    int? recordsTotal;
    int? recordsFiltered;
    List<Datum> ?data;
    bool ?status;
    int ?lastPageNumber;
    String ?currentPage;
    String ?itemPerPage;
    // Input ?input;

    factory Original.fromJson(Map<String, dynamic> json) => Original(
        draw: json["draw"] == null ? null : json["draw"],
        recordsTotal: json["recordsTotal"] == null ? null : json["recordsTotal"],
        recordsFiltered: json["recordsFiltered"] == null ? null : json["recordsFiltered"],
        data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        status: json["status"] == null ? null : json["status"],
        lastPageNumber: json["last_page_number"] == null ? null : json["last_page_number"],
        currentPage: json["current_page"] == null ? null : json["current_page"],
        itemPerPage: json["Item_per_page"] == null ? null : json["Item_per_page"],
        // input: json["input"] == null ? null : Input.fromJson(json["input"]),
    );

    Map<String, dynamic> toJson() => {
        "draw": draw == null ? null : draw,
        "recordsTotal": recordsTotal == null ? null : recordsTotal,
        "recordsFiltered": recordsFiltered == null ? null : recordsFiltered,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
        "status": status == null ? null : status,
        "last_page_number": lastPageNumber == null ? null : lastPageNumber,
        "current_page": currentPage == null ? null : currentPage,
        "Item_per_page": itemPerPage == null ? null : itemPerPage,
        // "input": input == null ? null : input?.toJson(),
    };
}

class Datum {
    Datum({
        this.id,
        this.usersId,
        this.imageFile,
        this.imageApprove,
        this.isPreference,
    });

    int? id;
    int? usersId;
    String? imageFile;
    String ?imageApprove;
    int? isPreference;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] == null ? null : json["id"],
        usersId: json["users_id"] == null ? null : json["users_id"],
        imageFile: json["image_file"] == null ? null : json["image_file"],
        imageApprove: json["image_approve"] == null ? null : json["image_approve"],
        isPreference: json["is_preference"] == null ? null : json["is_preference"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "users_id": usersId == null ? null : usersId,
        "image_file": imageFile == null ? null : imageFile,
        "image_approve": imageApprove == null ? null : imageApprove,
        "is_preference": isPreference == null ? null : isPreference,
    };
}

// class Input {
//     Input({
//         this.length,
//         this.page,
//     });

//     dynamic length;
//     dynamic page;

//     factory Input.fromJson(Map<String, dynamic> json) => Input(
//         length: json["length"],
//         page: json["page"],
//     );

//     Map<String, dynamic> toJson() => {
//         "length": length,
//         "page": page,
//     };
// }
