import 'package:event_bus/event_bus.dart';
import 'package:renting_assistant/model/house_cover_model.dart';
import 'package:renting_assistant/model/user_info.dart';

EventBus eventBus = EventBus();

class SendHouseTypeFilterEvent {
  int rentMode;
  int bedRoomCount;
  SendHouseTypeFilterEvent(int rentMode, int bedRoomCount) {
    this.rentMode = rentMode;
    this.bedRoomCount = bedRoomCount;
  }
}
class SendHouseMoreFilterEvent{
  bool isNearBySubway;
  bool hasLift;
  int areaClass;

  SendHouseMoreFilterEvent(bool isNearBySubway, bool hasLift, int areaClass) {
    this.isNearBySubway = isNearBySubway;
    this.hasLift = hasLift;
    this.areaClass = areaClass;
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

class PriceFilterContentEvent {
  int level;
  PriceFilterContentEvent(int level) {
    this.level = level;
  }
}

class RefreshHomeRecommendList{
  String refresh;
  RefreshHomeRecommendList(String refresh) {
    this.refresh = refresh;
  }
}

class RegionFilterEvent {
  String region;
  RegionFilterEvent(String region) {
    this.region = region;
  }
}

class LogOutEvent {}
class SignInEvent {}
class UpdateCollect {}
class ChangeTab {
  int index;
  ChangeTab(int index) {
    this.index = index;
  }
}
class NotifyPop {}
class RefreshQuestion {}
class SearchResult {
  String keyword;
  SearchResult(this.keyword);
}
class NotifyEditNicknameSuccess{
  UserInfo userInfo;
  NotifyEditNicknameSuccess(this.userInfo);
}

class NotifyEditEmailSuccess{
  UserInfo userInfo;
  NotifyEditEmailSuccess(this.userInfo);
}