import sys
sys.path.insert(1, '/home/jpal/dev/resume_be/src')

from funcs import get_visitors, add_visitors, sub_visitors
import pytest

class Funcs:
    def __init__(self):
        self.count = None
        self.payload = { 'key' : 1 }
    
    def get(self):
        res = get_visitors(self.payload, self.payload)
        self.count = int(res['body'])
        
        return res
    
    def add(self):
        res = add_visitors(self.payload, self.payload)
        
        return res
    
    def sub(self):
        res = sub_visitors(self.payload, self.payload)
        
        return res
    
    def increment(self):
        self.count += 1

@pytest.fixture(scope='module')
def func_class():
    return Funcs()
    
def test_get_visitors(func_class):
    res = func_class.get()

    assert type(res) == dict
    assert res['statusCode'] == 200

def test_add_visitors(func_class):
    res = func_class.add()

    assert res['statusCode'] == 200
    assert int(res['body']) == func_class.count + 1
    func_class.increment()

def test_sub_visitors(func_class):
    res = func_class.sub()

    assert res['statusCode'] == 200
    assert int(res['body']) == func_class.count - 1