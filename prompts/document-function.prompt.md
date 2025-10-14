---
description: "Generate NumPy-style docstrings for Python functions with type hints, parameters, returns, examples, and edge cases"
---

# Document Function

You are an expert Python developer specializing in technical documentation. Generate comprehensive NumPy-style docstrings for the selected function or class.

## Documentation Requirements

### 1. Summary

- One-line brief description (imperative mood: "Calculate", not "Calculates")
- Extended description if needed (2-3 sentences explaining purpose and context)

### 2. Parameters Section

```
Parameters
----------
param_name : type
    Description of parameter, including:
    - What it represents
    - Valid range/values if applicable
    - Default behavior if optional
```

### 3. Returns Section

```
Returns
-------
return_type
    Description of return value, including:
    - What it represents
    - Structure (if dict/list, explain contents)
    - Special values (None, empty, etc.)
```

### 4. Raises Section (if applicable)

```
Raises
------
ValueError
    When parameter validation fails (be specific)
TypeError
    When parameter has wrong type
KeyError
    When required key is missing
```

### 5. Examples Section

```
Examples
--------
>>> function_name(arg1, arg2)
expected_output

>>> # Edge case example
>>> function_name(edge_case_arg)
edge_case_output
```

### 6. Notes Section (if applicable)

- Performance considerations
- Implementation details
- Algorithm complexity (O notation)
- Related functions or alternative approaches

## Type Hints Requirements

Ensure the function signature includes modern Python 3.10+ type hints:

- Use `list[T]` not `List[T]`
- Use `dict[K, V]` not `Dict[K, V]`
- Use `X | Y` not `Union[X, Y]`
- Use `X | None` not `Optional[X]`

## Output Format

Provide the complete function with:

1. Type-hinted signature
2. Complete NumPy-style docstring
3. Original function body (unchanged)

Focus on clarity, completeness, and providing practical examples that demonstrate typical and edge-case usage.
