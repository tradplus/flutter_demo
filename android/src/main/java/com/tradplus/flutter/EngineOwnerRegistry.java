package com.tradplus.flutter;

import androidx.annotation.Nullable;

import java.util.ArrayList;
import java.util.List;

/** Tracks the Activity-backed Engine that owns process-wide TradPlus resources. */
final class EngineOwnerRegistry<T> {
    private static final class Entry<T> {
        final T engine;
        boolean hasActivity;

        Entry(T engine) {
            this.engine = engine;
        }
    }

    private final List<Entry<T>> entries = new ArrayList<>();
    @Nullable
    private Entry<T> owner;

    void attachEngine(T engine) {
        if (find(engine) == null) {
            entries.add(new Entry<>(engine));
        }
    }

    void attachActivity(T engine) {
        Entry<T> entry = find(engine);
        if (entry == null) {
            throw new IllegalStateException("Engine must attach before its Activity");
        }
        entry.hasActivity = true;
        if (owner == null) {
            owner = entry;
        }
    }

    void detachActivityForConfigChanges(T engine) {
        Entry<T> entry = find(engine);
        if (entry != null) {
            entry.hasActivity = false;
        }
    }

    void detachActivity(T engine) {
        Entry<T> entry = find(engine);
        if (entry == null) {
            return;
        }
        entry.hasActivity = false;
        if (owner == entry) {
            owner = firstActivityBackedEntry();
        }
    }

    void detachEngine(T engine) {
        Entry<T> entry = find(engine);
        if (entry == null) {
            return;
        }
        entries.remove(entry);
        if (owner == entry) {
            owner = firstActivityBackedEntry();
        }
    }

    boolean isOwner(T engine) {
        return owner != null && owner.engine == engine;
    }

    boolean isActivityOwner(T engine) {
        return isOwner(engine) && owner.hasActivity;
    }

    boolean isEmpty() {
        return entries.isEmpty();
    }

    @Nullable
    T getOwner() {
        return owner == null ? null : owner.engine;
    }

    @Nullable
    private Entry<T> firstActivityBackedEntry() {
        for (Entry<T> entry : entries) {
            if (entry.hasActivity) {
                return entry;
            }
        }
        return null;
    }

    @Nullable
    private Entry<T> find(T engine) {
        for (Entry<T> entry : entries) {
            if (entry.engine == engine) {
                return entry;
            }
        }
        return null;
    }
}
