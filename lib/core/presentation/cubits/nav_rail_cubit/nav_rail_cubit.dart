import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/nav_item.dart'; // Import NavItem

class NavRailCubit extends Cubit<NavItem> {
  NavRailCubit() : super(NavItem.favorites); // Default to 'Items'

  void selectNavItem(NavItem item) {
    emit(item);
  }
}