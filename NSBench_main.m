/* Generated by the NeXT Project Builder 
   NOTE: Do NOT change this file -- Project Builder maintains it.
*/

#import <appkit/appkit.h>

void main(int argc, char *argv[]) {
    [Application new];
    if ([NXApp loadNibSection:"NSBench.nib" owner:NXApp withNames:NO])
            [NXApp run];
            
    [NXApp free];
    exit(0);
}
