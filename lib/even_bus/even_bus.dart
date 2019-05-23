import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class SendHouseTypeFilterEvent {
  bool isSelectAllEntireRent = false;
  bool isSelectAllSharedRent = false;
  List<bool> entireRents = [false, false, false, false];
  List<bool> sharedRents = [false, false, false, false];
  SendHouseTypeFilterEvent(bool isSelectAllEntireRent, bool isSelectAllSharedRent, List<bool> entireRents, List<bool> sharedRents) {
    this.isSelectAllEntireRent = isSelectAllEntireRent;
    this.isSelectAllSharedRent = isSelectAllSharedRent;
    this.entireRents = entireRents;
    this.sharedRents = sharedRents;
  }
}
class SendHouseMoreFilterEvent{
  bool isNearBySubway;
  bool hasLift;
  List<bool> houseAreas;

  SendHouseMoreFilterEvent(bool isNearBySubway, bool hasLift, List<bool> houseAreas) {
    this.isNearBySubway = isNearBySubway;
    this.hasLift = hasLift;
    this.houseAreas = houseAreas;
  }
}
class ResetHouseTypeFilterEvent {
  String reset;
  ResetHouseTypeFilterEvent(String reset) {
    this.reset = reset;
  }
}

class ResetHouseMoreFilterEvent {
  String reset;
  ResetHouseMoreFilterEvent(String reset) {
    this.reset = reset;
  }
}

class CloseFilterContentEvent {
  String close;
  CloseFilterContentEvent(String close) {
    this.close = close;
  }
}

class RefreshHomeRecommendList{
  String refresh;
  RefreshHomeRecommendList(String refresh) {
    this.refresh = refresh;
  }
}