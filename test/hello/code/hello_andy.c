#include <stdio.h>

int main() {
	char name[64];
	while (scanf("%s",name)!=EOF) {
		printf("Hello %s\n",name);
	}
	return 0;
}

