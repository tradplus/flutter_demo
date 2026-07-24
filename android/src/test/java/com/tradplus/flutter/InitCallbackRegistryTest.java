package com.tradplus.flutter;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertSame;

import java.util.List;

import org.junit.Test;

public class InitCallbackRegistryTest {
    @Test
    public void sameAppAttemptsStartAndCompleteAllCallers() {
        InitCallbackRegistry<Object> registry = new InitCallbackRegistry<>();
        Object firstCaller = new Object();
        Object secondCaller = new Object();

        assertEquals(
                InitCallbackRegistry.Registration.START,
                registry.register("app-id", firstCaller));
        assertEquals(
                InitCallbackRegistry.Registration.START,
                registry.register("app-id", secondCaller));

        List<Object> callbacks = registry.complete();
        assertEquals(2, callbacks.size());
        assertSame(firstCaller, callbacks.get(0));
        assertSame(secondCaller, callbacks.get(1));
    }

    @Test
    public void differentAppIdIsRejectedForProcessLifetime() {
        InitCallbackRegistry<Object> registry = new InitCallbackRegistry<>();

        registry.register("first", new Object());
        registry.complete();

        assertEquals(
                InitCallbackRegistry.Registration.REJECT,
                registry.register("second", new Object()));
    }

    @Test
    public void stalledSameAppAttemptCanBeRetried() {
        InitCallbackRegistry<Object> registry = new InitCallbackRegistry<>();
        Object caller = new Object();

        assertEquals(
                InitCallbackRegistry.Registration.START,
                registry.register("app-id", caller));
        assertEquals(
                InitCallbackRegistry.Registration.START,
                registry.register("app-id", caller));

        List<Object> callbacks = registry.complete();
        assertEquals(1, callbacks.size());
        assertSame(caller, callbacks.get(0));
    }

    @Test
    public void detachedCallerIsNotNotifiedAfterSameAppRetry() {
        InitCallbackRegistry<Object> registry = new InitCallbackRegistry<>();
        Object detachedCaller = new Object();
        Object newCaller = new Object();

        registry.register("app-id", detachedCaller);
        registry.remove(detachedCaller);
        registry.register("app-id", newCaller);

        List<Object> callbacks = registry.complete();
        assertEquals(1, callbacks.size());
        assertSame(newCaller, callbacks.get(0));
    }
}
