#include "kernel.h"
#include <iostream>
#include <map>
#include <thread>
#include <stdlib.h>
#include <opencv2/opencv.hpp>
using namespace std;
int callCount = 0;
void callBack()
{
	while(callCount<=100) {
		callCount++;
		cout<<"call back time is: "<<callCount<<endl;
	}
	exit(0);
	cout<<"thread finished"<<endl;
}
void thFunc(void) {
	printf("from another thread\n");
}
int main(int argc, char* argv[])
{
	std::thread t = std::thread(thFunc);
	std::cout<<"from main"<<std::endl;
	cv::Mat test = cv::imread("/ext_data/test.png");
	std::cout<<"Mat cols: "<<test.cols<<std::endl;
	const int arraySize = 5;
	const int a[arraySize] = {1,2,3,4,5};
	const int b[arraySize] = {10,20,30,40,50};
	int c[arraySize] = {0};
	cudaAdd(c,a,b,arraySize);
	printf("c: %d, %d, %d, %d, %d\n",c[0],c[1],c[2],c[3],c[4]);	
	gpuPrintf();
	/*std::map<int,char> test;
	int i = 0;
	for(auto t: test)
	{
		std::cout<<i++<<std::endl;
	}
	thread t1(callBack);
	t1.join();
	cout<<"thread complete"<<endl;*/
	return 0;
}
