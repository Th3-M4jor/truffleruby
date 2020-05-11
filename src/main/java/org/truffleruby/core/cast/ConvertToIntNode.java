/*
 * Copyright (c) 2015, 2019 Oracle and/or its affiliates. All rights reserved. This
 * code is released under a tri EPL/GPL/LGPL license. You can use it,
 * redistribute it and/or modify it under the terms of the:
 *
 * Eclipse Public License version 2.0, or
 * GNU General Public License version 2, or
 * GNU Lesser General Public License version 2.1.
 */
package org.truffleruby.core.cast;

import org.truffleruby.Layouts;
import org.truffleruby.language.RubyContextSourceNode;
import org.truffleruby.language.RubyNode;
import org.truffleruby.language.control.RaiseException;
import org.truffleruby.language.dispatch.CallDispatchHeadNode;

import com.oracle.truffle.api.dsl.Cached;
import com.oracle.truffle.api.dsl.NodeChild;
import com.oracle.truffle.api.dsl.Specialization;
import com.oracle.truffle.api.object.DynamicObject;
import com.oracle.truffle.api.profiles.BranchProfile;

// TODO: ToIntNode => ConvertToLongNode => ToLongNode, ConvertToIntNode => ToIntNode
@NodeChild(value = "child", type = RubyNode.class)
public abstract class ConvertToIntNode extends RubyContextSourceNode {

    public static ConvertToIntNode create() {
        return ConvertToIntNodeGen.create(null);
    }

    public static ConvertToIntNode create(RubyNode child) {
        return ConvertToIntNodeGen.create(child);
    }

    public abstract int execute(Object object);

    @Specialization
    protected int coerceInt(int value) {
        return value;
    }

    @Specialization(guards = "fitsInInteger(value)")
    protected int corceFittingLong(long value) {
        return (int) value;
    }

    @Specialization(guards = "!fitsInInteger(value)")
    protected int coerceTooBigLong(long value) {
        // MRI does not have this error
        throw new RaiseException(
                getContext(),
                coreExceptions().argumentError("long too big to convert into `int'", this));
    }

    @Specialization(guards = "isRubyBignum(value)")
    protected int coerceRubyBignum(DynamicObject value) {
        // not `int' to stay as compatible as possible with MRI errors
        throw new RaiseException(
                getContext(),
                coreExceptions().rangeError("bignum too big to convert into `long'", this));
    }

    @Specialization
    protected int coerceDouble(double value,
            @Cached BranchProfile errorProfile) {
        int intValue = (int) value;
        if (intValue == Integer.MAX_VALUE && value > Integer.MAX_VALUE ||
                intValue == Integer.MIN_VALUE && value < Integer.MIN_VALUE) {
            errorProfile.enter();
            coerceRubyBignum(null);
        }
        return intValue;
    }

    @Specialization(guards = "!isRubyBignum(object)")
    protected int coerceObject(Object object,
            @Cached CallDispatchHeadNode toIntNode,
            @Cached ConvertToIntNode fitNode,
            @Cached BranchProfile errorProfile) {
        final Object coerced;
        try {
            coerced = toIntNode.call(object, "to_int");
        } catch (RaiseException e) {
            errorProfile.enter();
            if (Layouts.BASIC_OBJECT.getLogicalClass(e.getException()) == coreLibrary().noMethodErrorClass) {
                throw new RaiseException(
                        getContext(),
                        coreExceptions().typeErrorNoImplicitConversion(object, "Integer", this));
            } else {
                throw e;
            }
        }

        if (coreLibrary().getLogicalClass(coerced) != coreLibrary().integerClass) {
            errorProfile.enter();
            throw new RaiseException(
                    getContext(),
                    coreExceptions().typeErrorBadCoercion(object, "Integer", "to_int", coerced, this));
        }

        return fitNode.execute(coerced);
    }
}
