package com.tradplus.flutter;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertSame;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

public class EngineOwnerRegistryTest {
    @Test
    public void headlessSecondaryEngineDoesNotReplaceOrClearOwner() {
        EngineOwnerRegistry<Object> registry = new EngineOwnerRegistry<>();
        Object uiEngine = new Object();
        Object backgroundEngine = new Object();

        registry.attachEngine(uiEngine);
        registry.attachActivity(uiEngine);
        registry.attachEngine(backgroundEngine);

        assertSame(uiEngine, registry.getOwner());
        assertFalse(registry.isActivityOwner(backgroundEngine));

        registry.detachEngine(backgroundEngine);

        assertSame(uiEngine, registry.getOwner());
        assertTrue(registry.isActivityOwner(uiEngine));
    }

    @Test
    public void prewarmedEngineCanAttachBeforeItHasAnActivity() {
        EngineOwnerRegistry<Object> registry = new EngineOwnerRegistry<>();
        Object prewarmedEngine = new Object();

        registry.attachEngine(prewarmedEngine);

        assertNull(registry.getOwner());

        registry.attachActivity(prewarmedEngine);

        assertSame(prewarmedEngine, registry.getOwner());
        assertTrue(registry.isActivityOwner(prewarmedEngine));
    }

    @Test
    public void configChangePreservesOwnerUntilReattach() {
        EngineOwnerRegistry<Object> registry = new EngineOwnerRegistry<>();
        Object firstEngine = new Object();
        Object secondEngine = new Object();

        registry.attachEngine(firstEngine);
        registry.attachActivity(firstEngine);
        registry.attachEngine(secondEngine);
        registry.attachActivity(secondEngine);

        registry.detachActivityForConfigChanges(firstEngine);

        assertSame(firstEngine, registry.getOwner());
        assertFalse(registry.isActivityOwner(firstEngine));
        assertFalse(registry.isActivityOwner(secondEngine));

        registry.attachActivity(firstEngine);

        assertSame(firstEngine, registry.getOwner());
        assertTrue(registry.isActivityOwner(firstEngine));
    }

    @Test
    public void permanentActivityDetachPromotesAttachedCandidate() {
        EngineOwnerRegistry<Object> registry = new EngineOwnerRegistry<>();
        Object firstEngine = new Object();
        Object secondEngine = new Object();

        registry.attachEngine(firstEngine);
        registry.attachActivity(firstEngine);
        registry.attachEngine(secondEngine);
        registry.attachActivity(secondEngine);

        registry.detachActivity(firstEngine);

        assertSame(secondEngine, registry.getOwner());
        assertTrue(registry.isActivityOwner(secondEngine));
    }

    @Test
    public void ownerEngineDetachPromotesAttachedCandidate() {
        EngineOwnerRegistry<Object> registry = new EngineOwnerRegistry<>();
        Object firstEngine = new Object();
        Object secondEngine = new Object();

        registry.attachEngine(firstEngine);
        registry.attachActivity(firstEngine);
        registry.attachEngine(secondEngine);
        registry.attachActivity(secondEngine);

        registry.detachEngine(firstEngine);

        assertSame(secondEngine, registry.getOwner());
        assertTrue(registry.isActivityOwner(secondEngine));
    }
}
