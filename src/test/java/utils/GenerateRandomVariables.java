package utils;

import com.github.javafaker.Faker;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.util.*;

public class GenerateRandomVariables {
    public static Faker faker = new Faker();

    public static String randomName() {
        return "AutomatedTestUserGroup- "+faker.company().name().toString();
    }

    public static String randomTime() {
        DateFormat dateFormat = new SimpleDateFormat("YYYY-MM-dd");
        Date date = new Date();
        return dateFormat.format(date);
    }

    public static String randomEmail() {
        return faker.internet().emailAddress();
    }

    public static String randomUrl() {
        return faker.company().url();
    }

    public static String randomUuid() {
        return UUID.randomUUID().toString();
    }

    public static String randomNum() {
        return faker.numerify("####-##");
    }

    public static int randomDigit() {
        Random random = new Random();
        return random.nextInt(20);
    }

    public static String randomFirstName() {
        return "AutomatedTestUser-"+faker.name().firstName();
    }

    public static String randomLastName() {
        return faker.name().lastName();
    }

    public static String randomAddress() {
        return faker.address().fullAddress();
    }

    public static String randomSubCategory() {
        List<String> subCategoryList = new ArrayList<>(Arrays.asList("sbe", "hub", "wbe", "mbe", "sdb"));
        Random random = new Random();
        return subCategoryList.get(random.nextInt(subCategoryList.size()));
    }

    public static boolean randomTrueFalse() {
        Random random = new Random();
        return random.nextBoolean();
    }

    public static String randomPassword() {
        return faker.internet().password(8,24,true,true,true);
    }

    public static String randomOrgType() {
        List<String> orgTypeList = new ArrayList<>(Arrays.asList("supplier","buyer","partner"));
        Random random = new Random();
        return orgTypeList.get(random.nextInt(orgTypeList.size()));
    }
    public static String randomPermissionGroups() {
        List<String> permissionGroupList = new ArrayList<>(Arrays.asList("Orca Client","Support","CDA","IT ADMIN","DEV_TEST","Dev Users"));
        Random random = new Random();
        return permissionGroupList.get(random.nextInt(permissionGroupList.size()));
    }

    public static String currentUtcTimeStamp() {
        return Instant.now().toString();
    }

}
