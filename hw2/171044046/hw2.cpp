#include <iostream> 

using namespace std;

int MAX_SIZE = 100;

int CheckSumPossibility(int num, int arr[], int size) 
{ 
    if (num == 0)
        return 1;

    else if (size == 0)
        return 0;
    
    else if (arr[size-1] > num)
         return CheckSumPossibility(num, arr, size-1);

    int return1 = CheckSumPossibility(num, arr, size-1);
    int return2 = CheckSumPossibility(num-arr[size-1], arr, size-1);

    return return1 || return2;
} 

int main() 
{
    int arraySize;
    int arr[MAX_SIZE];
    int num;
    int returnVal;

    cout << "Enter size : ";
    cin >> arraySize;
    cout << "Enter target num: ";
    cin >> num;

    cout << "Enter array elements: ";
    for(int i = 0; i < arraySize; ++i)
    {
        cin >> arr[i];
    }

    returnVal = CheckSumPossibility(num, arr, arraySize);

    if(returnVal == 1)
    {
        cout << "Possible!" << endl;
    }
    else
    {
        cout << "Not possible!" << endl;
    }

    return 0;
}
