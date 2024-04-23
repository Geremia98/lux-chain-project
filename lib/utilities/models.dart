class BuyInfo {
  final int watchid;
  final String brandName;
  final String modelName;
  final double actualPrice;
  final double proposalPrice;
  final int totalNumberOfShares;
  final int numberOfShares;
  final String image;

  const BuyInfo({
    required this.watchid,
    required this.brandName,
    required this.modelName,
    required this.actualPrice,
    required this.proposalPrice,
    required this.totalNumberOfShares,
    required this.numberOfShares,
    required this.image,
  });
}