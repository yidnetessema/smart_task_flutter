class showMoreStates {
  bool isShowMore;
  showMoreStates({required this.isShowMore});
}

class InitStates extends showMoreStates {
  InitStates() : super(isShowMore: false);
}
