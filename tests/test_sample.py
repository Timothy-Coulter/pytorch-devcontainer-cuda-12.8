import pytest


def test_sample_pass():
    """A simple passing test to verify pytest is working."""
    assert 1 + 1 == 2


def test_sample_fail():
    """A simple failing test for demonstration purposes."""
    assert 1 + 1 == 3  # This will fail


@pytest.mark.parametrize("input,expected", [
    (1, 2),
    (2, 4),
    (3, 6),
])
def test_sample_parametrized(input, expected):
    """A parametrized test to show pytest features."""
    assert input * 2 == expected