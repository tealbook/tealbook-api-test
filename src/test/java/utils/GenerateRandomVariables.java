package utils;

import com.github.javafaker.Faker;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;

public class GenerateRandomVariables {
    public static Faker faker = new Faker();

    public static String randomName(){return faker.company().name().toString();}
    public static String randomTime(){
        DateFormat dateFormat = new SimpleDateFormat("YYYY-MM-dd");
        Date date = new Date();
        return dateFormat.format(date);
    }
    public static String randomEmail(){return faker.internet().emailAddress();}
    public static String randomUrl(){return faker.company().url();}
    public static String randomUuid(){return UUID.randomUUID().toString();}
    public static String randomNum(){return faker.numerify("####-##");}
    public static String randomFirstName(){return faker.name().firstName(); }
    public static String randomLastName(){return faker.name().lastName(); }
    public static String randomAddress(){return faker.address().fullAddress();}
    public static String randomSubCategory(){
        List<String> subCategoryList = new ArrayList<>(Arrays.asList("sbe","hub","wbe","mbe","sdb"));
        Random random = new Random();
        return subCategoryList.get(random.nextInt(subCategoryList.size()));
    }




}
