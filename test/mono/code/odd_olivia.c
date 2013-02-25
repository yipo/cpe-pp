#include <stdio.h>

int main() {
	int x;
	while (scanf("%d",&x)!=EOF) {
		printf("%s\n",(x%2==1)?"yes":"no");
	}
	return 0;
}

