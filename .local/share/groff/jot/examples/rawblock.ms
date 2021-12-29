.TL
Code blocks example
.LP
Code blocks allow users to delegate sections as not to be newlined. 
This can be used for many things, though code is what it's designed for.
.LD
.ft CW
int main(void) {
    for (int i = 0; i < 20; i++)
        printf("%d ", i);
    putchar('\n');
}
.ft
.LP
As you can see, it also uses monospaced fonts for code sections, a necessity
when reading anything with more than a few levels of indentation.
