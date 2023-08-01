// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paymentDetails.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaymentDetailsAdapter extends TypeAdapter<PaymentDetails> {
  @override
  final int typeId = 0;

  @override
  PaymentDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentDetails(
      offerAmount: fields[3] as int?,
      planId: fields[2] as int?,
      paymentId: fields[4] as int?,
      offerCode: fields[5] as int?,
      razorpayPaymentId: fields[0] as String?,
      razorpayStatus: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PaymentDetails obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.razorpayPaymentId)
      ..writeByte(1)
      ..write(obj.razorpayStatus)
      ..writeByte(2)
      ..write(obj.planId)
      ..writeByte(3)
      ..write(obj.offerAmount)
      ..writeByte(4)
      ..write(obj.paymentId)
      ..writeByte(5)
      ..write(obj.offerCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
