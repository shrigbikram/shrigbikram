class TipsDataModel{
  String imagePath;
  String title;
  String description;

  TipsDataModel({this.imagePath, this.title, this.description});

  String getImageAssetPath(){
    return imagePath;
  }

  void setImageAssetPath(String imagePath){
    this.imagePath = imagePath;
  }
  
  String getTitle(){
    return title;
  }

  void setTitle(String title){
    this.title = title;
  }

  String getDescription(){
    return description;
  }

  void setDescription(String description){
    this.description = description;
  }
}

List <TipsDataModel> getslidesdata() {

  List <TipsDataModel> slides = [];// new List<TipsDataModel>();
  
  //1
  TipsDataModel tipsmodel = new TipsDataModel();
  tipsmodel.setImageAssetPath("imagePath");
  tipsmodel.setTitle("Tip #1");
  tipsmodel.setDescription("A freshwater tank is recommended to start out with. This will teach you how to care for and maintain your tank before you take it up a notch and start a saltwater tank!");

  slides.add(tipsmodel);

  //2
  tipsmodel = new TipsDataModel();
  tipsmodel.setImageAssetPath("imagePath");
  tipsmodel.setTitle("Tip #2");
  tipsmodel.setDescription("Feed your fish daily, but make sure you don’t feed them too much!");

  slides.add(tipsmodel);


  //3
  tipsmodel = new TipsDataModel();
  tipsmodel.setImageAssetPath("imagePath");
  tipsmodel.setTitle("Tip #3");
  tipsmodel.setDescription("Clean your tank regularly, we recommend a 25% water change weekly, 50% every 2 weeks or a 90% change once a month.");

  slides.add(tipsmodel);

  //4
  tipsmodel = new TipsDataModel();
  tipsmodel.setImageAssetPath("imagePath");
  tipsmodel.setTitle("Tip #4");
  tipsmodel.setDescription("Be sure you have some room around all sides of your tank. There will be drips to clean up, and you have to account for the other equipment that will be placed on your tank.");

  slides.add(tipsmodel);


  //5
  tipsmodel = new TipsDataModel();
  tipsmodel.setImageAssetPath("imagePath");
  tipsmodel.setTitle("Tip #5");
  tipsmodel.setDescription("Make sure your tank is near a power outlet.");

  slides.add(tipsmodel);


  //6
  tipsmodel = new TipsDataModel();
  tipsmodel.setImageAssetPath("imagePath");
  tipsmodel.setTitle("Tip #6");
  tipsmodel.setDescription("Have a stand that can withhold the weight of your tank. Rule of thumb= Multiply the amount gallons x 10 for a rough weight.");

  slides.add(tipsmodel);

  //7
  tipsmodel = new TipsDataModel();
  tipsmodel.setImageAssetPath("imagePath");
  tipsmodel.setTitle("Tip #7");
  tipsmodel.setDescription("Test your water at least once a week.");

  slides.add(tipsmodel);

  //8
  tipsmodel = new TipsDataModel();
  tipsmodel.setImageAssetPath("imagePath");
  tipsmodel.setTitle("Tip #8");
  tipsmodel.setDescription("Pay attention to your fish at least twice a day. They notice!");

  slides.add(tipsmodel);

  //9
  tipsmodel = new TipsDataModel();
  tipsmodel.setImageAssetPath("imagePath");
  tipsmodel.setTitle("Tip #9");
  tipsmodel.setDescription("Remove algae weekly.");

  slides.add(tipsmodel);

  //10
  tipsmodel = new TipsDataModel();
  tipsmodel.setImageAssetPath("imagePath");
  tipsmodel.setTitle("Tip #10");
  tipsmodel.setDescription("Change the decorations at least twice a year. We don’t want your fish bored!");

  slides.add(tipsmodel);

  return slides;
}