import com.intuit.karate.RuntimeHook;
import com.intuit.karate.Suite;
import com.intuit.karate.core.FeatureRuntime;
import com.intuit.karate.core.ScenarioRuntime;
import com.intuit.karate.core.Step;
import com.intuit.karate.core.StepResult;
import org.junit.platform.commons.logging.Logger;
import org.junit.platform.commons.logging.LoggerFactory;

public class KarateHook implements RuntimeHook {
    private static final Logger logger = LoggerFactory.getLogger(KarateHook.class);

    public KarateHook() {
    }

    @Override
    public boolean beforeScenario(ScenarioRuntime sr) {
        return true;
    }

    @Override
    public void afterScenario(ScenarioRuntime sr) {
    }

    @Override
    public boolean beforeFeature(FeatureRuntime sr) {
        return true;
    }

    @Override
    public void afterFeature(FeatureRuntime sr) {
    }

    @Override
    public void beforeSuite(Suite suite) {
    }

    @Override
    public void afterSuite(Suite suite) {
    }

    @Override
    public boolean beforeStep(Step step, ScenarioRuntime sr) {
        return true;
    }

    @Override
    public void afterStep(StepResult stepResult, ScenarioRuntime sr) {

    }


}
