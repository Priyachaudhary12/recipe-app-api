"""
Sample tests

"""
from django.test import SimpleTestCase
from app import calc
class CalcTests(SimpleTestCase):
    """Test the calc module"""

    def test_add_numbers(self):
        """Test Adding numbers together"""
        res=calc.add(5,6)
        self.assertEqual(res,11)

    def test_subtract_numbers(self):
        """Test Subtracting numbers together"""
        res=calc.subtract(10,15)
        self.assertEqual(res,5)

    def test_num_check(self):
        my_list=[1,3,5,7]
        res=calc.num_check(my_list)
        self.assertEqual(res,["1 is an odd number", "3 is an odd number", "5 is an odd number", "7 is an odd number"])
