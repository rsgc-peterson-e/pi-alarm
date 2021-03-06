import java.util.Calendar; // for keeping time as opposed to built in processing functions
//import processing.io.*; // IO library to control the raspberry Pi's GPIO pins to detect button presses
// for now navigation will be done with the keyboard for testing purposes
// the library will be included when the program is compiled for raspberry pi

class Util implements TimeUtils, WeatherUtils {

  Resource r = new Resource();
  Calendar c;

  // useful variables for all classes
  // time slide
  public int minute;
  public int hour;
  public int day;
  public int weekDay;
  public int month;
  public int year;
  public int dayNum;
  public String theDate;
  public boolean isPM;
  private String p1Time = "  (8:15 AM - 9:30 AM)";
  private String p2Time = "  (9:35 AM - 10:50 AM)";
  private String p3Time = "  (11:15 AM - 12:30 PM)";
  private String p4Time = "  (1:25 PM - 2:40 PM)";

  // weather variables
  private XML weather;
  private boolean xmlAvailable;
  private int currentTemp; // string storing current temperature returned by getTemp()
  private String url; // stores url of XML file + city and province
  private int arraySize = 10; // will be int to store the array size because all the arrays to do with the forecast should be the same size
  private String[] dayOfWeek = new String[arraySize]; // array to store day of the week for the weather forecast advancing from the current day
  private String[] date = new String[arraySize]; // array to hold forecast dates so users know what day they are viewing the forecast for
  private int[] low = new int[arraySize]; // 5 slots for each day of the week in the forecast of the low temps
  private int[] high = new int[arraySize]; // array of high daily temps in the forecast
  private String[] text = new String[arraySize]; // will hold comment on forecast ex. "AM Showers"
  // current the length of the all forecast arrays is 5
  private XML[] forecast; // XML array storing the forecast for each
  private XML onlineXML; // online weather XML
  //extracurrciular XML
  private XML extras;
  private XML[] children;
  private XML schoolSchedule; // schedule XML
  private XML[] sChildren; // children of day tag


  void Util() { // do the initial setting of the variables in the constructor
    c = Calendar.getInstance();
    minute = c.get(Calendar.MINUTE); // update the time variables as shortcuts to accessing the calendar
    hour = c.get(Calendar.HOUR);
    day = c.get(Calendar.DAY_OF_MONTH);
    weekDay = c.get(Calendar.DAY_OF_WEEK);
    month = c.get(Calendar.MONTH) + 1;
    year = c.get(Calendar.YEAR);
    theDate = u.getWeekDay(u.weekDay) + ", " + u.getMonth(u.month) + " " + u.day + " " + u.year;
  }


  void update() { // function will contain any variables that needed to be updated continuously in draw function
    c = Calendar.getInstance(); // reseting the object in a loop will update it to the latest time
    minute = c.get(Calendar.MINUTE);
    hour = c.get(Calendar.HOUR);
    day = c.get(Calendar.DAY_OF_MONTH);
    weekDay = c.get(Calendar.DAY_OF_WEEK);
    month = c.get(Calendar.MONTH) + 1;
    year = c.get(Calendar.YEAR);
    theDate = u.getWeekDay(u.weekDay) + ", " + u.getMonth(u.month) + " " + u.day + " " + u.year;
  }


  boolean countDown(int min, int startTime) { // will return true once a specified number of minutes has passed for the snooze button
    if (millis() - startTime >= min) {
      return true;
    } else {
      return false;
    }
  }


  String getMonth(int m) { // takes month var as input
    if (m == 1) { //return the right month string depending on what number from 1-12 is inputted into the function
      return "January";
    } else if (m == 2) {
      return "February";
    } else if (m == 3) {
      return "March";
    } else if (m == 4) {
      return "April";
    } else if (m == 5) {
      return "May";
    } else if (m == 6) {
      return "June";
    } else if (m == 7) {
      return "July";
    } else if (m == 8) {
      return "August";
    } else if (m == 9) {
      return "September";
    } else if (m == 10) {
      return "October";
    } else if (m == 11) {
      return "November";
    } else if (m == 12) {
      return "December";
    } else {
      return "Error";
    }
  }


  String getWeekDay(int w) { // function returns a weekday based on what number is given by the Java Calendar class
    if (w == 1) {
      return "Sunday";
    } else if (w == 2) {
      return "Monday";
    } else if (w == 3) {
      return "Tuesday";
    } else if (w == 4) {
      return "Wednesday";
    } else if (w == 5) {
      return "Thursday";
    } else if (w == 6) {
      return "Friday";
    } else if (w == 7) {
      return "Saturday";
    } else {
      return "Error";
    }
  }


  String get12HourTime() { // returns a String of the time in 12 hour form
    if (c.get(Calendar.HOUR_OF_DAY) >= 12) { // checks if the hour of the day is greater or equal to 12 meaning it is the afternoon
      isPM = true;
    }
    if (c.get(Calendar.HOUR_OF_DAY) < 12) { // checks if the hour of the day is less than 12 meaning it is the morning
      isPM = false;
    }
    if (!isPM && minute >= 10) {
      return hour + ":" + minute + " AM";
    } else if (!isPM && minute < 10) { // add 0 padding if the minute is below 10
      return hour + ":" + "0" + minute + " AM";
    } else if (isPM && minute >= 10 && hour != 0) {
      return hour + ":" + minute + " PM";
    } else if (isPM && minute < 10 && hour != 0) {
      return hour + ":" + "0" + minute + " PM";
    } else if (isPM && hour == 0 && minute < 10) {
      return "12:" + "0" + minute + " PM";
    } else if (isPM && hour == 0 && minute >= 10) {
      return "12:" + minute + " PM";
    } else {
      return "Error";
    }
  }


  public int getMonthLength(int m) {
    if (m == 2) {
      return 28; // return the feburary's amount of days which is 28
    } else if (m == 1 || m == 3 || m == 5 || m == 7 || m == 8 || m == 10 || m == 12) {
      return 31; // return 31 as these months of the year are 31 days long
    } else {
      return 30; // return the 30 day month in all other cases
    }
  } 

  String[] getSchedule(int d) {
    String[] schedule = new String[4];
    schoolSchedule = loadXML("assets/xml/schedule.xml");
    sChildren = schoolSchedule.getChildren("day"); // collect the correct strings from XML array of the XML tags called day
    if (d == 1) {
      schedule[0] = "P1: " + sChildren[0].getString("p1") + p1Time; // use the strings for the schedule this way the xml can be modified for schedule changes
      schedule[1] = "P2: " + sChildren[0].getString("p2") + p2Time;
      schedule[2] = "P3: " + sChildren[0].getString("p3") + p3Time;
      schedule[3] = "P4: " + sChildren[0].getString("p4") + p4Time;
    }
    if (d == 2) {
      schedule[0] = "P1: " + sChildren[1].getString("p1") + p1Time;
      schedule[1] = "P2: " + sChildren[1].getString("p2") + p2Time;
      schedule[2] = "P3: " + sChildren[1].getString("p3") + p3Time;
      schedule[3] = "P4: " + sChildren[1].getString("p4") + p4Time;
    }
    if (d == 3) {
      schedule[0] = "P1: " + sChildren[2].getString("p1") + p1Time;
      schedule[1] = "P2: " + sChildren[2].getString("p2") + p2Time;
      schedule[2] = "P3: " + sChildren[2].getString("p3") + p3Time;
      schedule[3] = "P4: " + sChildren[2].getString("p4") + p4Time;
    }
    if (d == 4) {
      schedule[0] = "P1: " + sChildren[3].getString("p1") + p1Time;
      schedule[1] = "P2: " + sChildren[3].getString("p2") + p2Time;
      schedule[2] = "P3: " + sChildren[3].getString("p3") + p3Time;
      schedule[3] = "P4: " + sChildren[3].getString("p4") + p4Time;
    }
    return schedule;
  }

  // weather functions:
  void setWeather(String city, String provCode) {
    url = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22" + city + "%2C%20" + provCode + "%22)%20and%20u%3D'c'&format=xml&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys";
    try { // tries a line of code allowing an error in this case NullPointer Exception to be caught and handled
      onlineXML = loadXML(url);
      saveXML(onlineXML, "assets/xml/weather.xml"); // loads XML file with the weather from Yahoo feed
      weather = loadXML("assets/xml/weather.xml");
      xmlAvailable = true; // will stay true if there is no NullPointerException
      forecast = weather.getChildren("results/channel/item/yweather:forecast");
    } 
    catch (NullPointerException e) {
      println("weather XML is null");
      xmlAvailable = false;
    }
    println(xmlAvailable);
  }


  public boolean xmlAvail() { // functions allowing me to check if the weather xml file exists outside the class
    return xmlAvailable;
  }


  public void updateXML() { // will be called in PiAlarm every hour to get the latest weather feed from Yahoo
    try { // tries a line of code allowing an error in this case NullPointer Exception to be caught and handled
      onlineXML = loadXML(url); // loads XML file with the weather from Yahoo feed
      saveXML(onlineXML, "assets/xml/weather.xml");
      weather = loadXML("assets/xml/weather.xml");
      xmlAvailable = true; // will stay true if there is no NullPointerException
      forecast = weather.getChildren("results/channel/item/yweather:forecast");
    } 
    catch (NullPointerException e) {
      println("weather XML is null");
      xmlAvailable = false;
    }
    println(xmlAvailable);
  }


  public int getTemp() { // gets current temperature
    if (xmlAvailable) {
      currentTemp = weather.getChild("results/channel/item/yweather:condition").getInt("temp");
      return currentTemp;
    } else {
      return -175; // return -175 if the function did not work due to XML File being null
    }
  }


  public String getWeather() { // will return weather conditions of the very moment
    if (xmlAvailable) {
      return weather.getChild("results/channel/item/yweather:condition").getString("text"); 
    } else {
      return "ERROR";
    }
  }


  public String getLocation() {
    if (xmlAvailable) {
      return weather.getChild("results/channel/yweather:location").getString("city") + ", " + weather.getChild("results/channel/yweather:location").getString("region"); 
    } else {
      return "ERROR";
    }
  }


  public String[][] getForecast() { // function returns array of type String that is demensions meaning it is like a matrix which is filled with the week's forecast
    //                      5x5 array would give a total of 25 spaces
    String[][] dayForecast = new String[arraySize][arraySize]; // first axis of the array will be the day and second will be the component of forecast you wish to access ex. high temp for the day
    if (xmlAvailable) {
      for (int i = 0; i < forecast.length; i++) { // indexes weather forecast for the next 5 days into arrays
        dayOfWeek[i] = forecast[i].getString("day");  // fill local arrays with data from the XML file for easier access
        date[i] = forecast[i].getString("date");
        low[i] = forecast[i].getInt("low");
        high[i] = forecast[i].getInt("high");
        text[i] = forecast[i].getString("text");
        for (int j = 0; j < arraySize; j++) {
          dayForecast[j][0] = dayOfWeek[j];
          dayForecast[j][1] = text[j];
          dayForecast[j][2] = Integer.toString(high[j]); // add toString function as high array is of type float and so is the low array also uses the F2C function to get Celsius temp
          dayForecast[j][3] = Integer.toString(low[j]);
          dayForecast[j][4] = date[j];
        }
      }
    }
    return dayForecast;
  }
  //extra and schedule XML
  public String[] getExtras() { // collects extra currcicular activity strings from XML file using for loop iterating through arrays
    extras = loadXML("assets/xml/extras.xml");
    children = extras.getChildren("extra");
    String[] extraActivities = new String[children.length];
    for (int i = 0; i < children.length; i++) {
      extraActivities[i] = children[i].getString("activity");
    }
    return extraActivities;
  }
  public String[] getDays() {// collects extra currcicular activity day strings from XML file using for loop iterating through arrays
    extras = loadXML("assets/xml/extras.xml");
    children = extras.getChildren("extra");
    String[] days = new String[children.length];
    for (int i = 0; i < children.length; i++) {
      days[i] = children[i].getContent();
    }
    return days;
  }
}