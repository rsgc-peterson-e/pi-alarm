import java.util.Calendar; // for keeping time as opposed to built in processing functions
import java.util.Date; // for getting the date from system time and updating the calendar object
//import processing.io.*; // IO library to control the raspberry Pi's GPIO pins to detect button presses
// for now navigation will be done with the keyboard for testing purposes
// the library will be included when the program is compiled for raspberry pi

class Util {

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
  public String theDate;
  public boolean isPM;
  private long startTime; // long is like an int that can holder a larger value

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

  void switchSlideFrom(int s) {
    if (keyPressed && key == CODED) {
      if (keyCode == RIGHT) {
        if (s == 0) {
          r.slide = 1;
        }
        if (s == 1) {
          r.slide = 2;
        }
        if (s == 2) {
          r.slide = 3;
        }
        if (s == 3) {
          r.slide = 0;
        }
      }
      if (keyCode == LEFT) {
        if (s == 0) {
          r.slide = 3;
        }
        if (s == 1) {
          r.slide = 0;
        }
        if (s == 2) {
          r.slide = 1;
        }
        if (s == 3) {
          r.slide = 2;
        }
      }
    }
  }
}