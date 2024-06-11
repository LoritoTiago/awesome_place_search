class GetTitleService {
  static String call({required String firstText, required String sendText}) {
    final titleSplit = firstText.toLowerCase().split(",").map((e) => e.trim());

    final subtitleSplit =
        sendText.toLowerCase().split(",").map((e) => e.trim());

    Set<String> setTitle = Set.from(titleSplit);
    Set<String> setSubtitle = Set.from(subtitleSplit);

    Set<String> difference = setTitle.difference(setSubtitle);

    return List.from(difference).join(", ").toUpperCase();
  }
}
