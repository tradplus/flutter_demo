package com.tradplus.flutter;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/** Coordinates callers of the process-wide TradPlus initialization listener. */
final class InitCallbackRegistry<T> {
    enum Registration {
        START,
        REJECT
    }

    private final List<T> callbacks = new ArrayList<>();
    @Nullable
    private String processAppId;

    synchronized Registration register(@NonNull String requestedAppId, @NonNull T callback) {
        if (processAppId != null && !processAppId.equals(requestedAppId)) {
            return Registration.REJECT;
        }
        processAppId = requestedAppId;
        addIfAbsent(callback);
        return Registration.START;
    }

    @NonNull
    synchronized List<T> complete() {
        List<T> pending = new ArrayList<>(callbacks);
        callbacks.clear();
        return pending;
    }

    synchronized void remove(@NonNull T callback) {
        Iterator<T> iterator = callbacks.iterator();
        while (iterator.hasNext()) {
            if (iterator.next() == callback) {
                iterator.remove();
            }
        }
    }

    private void addIfAbsent(@NonNull T callback) {
        for (T pending : callbacks) {
            if (pending == callback) {
                return;
            }
        }
        callbacks.add(callback);
    }
}
