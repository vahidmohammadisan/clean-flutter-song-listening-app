import 'package:equatable/equatable.dart';

class Muzic extends Equatable {

  const Muzic({
    this.Name,
    this.Signer,
    this.Link
  });

  final String Name;
  final String Signer;
  final String Link;

  @override
  // TODO: implement props
  List<Object> get props => [Name, Signer, Link];

}