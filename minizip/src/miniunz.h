#ifndef MINIUNZ_H
#define MINIUNZ_H

#ifdef __cplusplus
extern "C" {
#endif

int miniunz(int argc , char *argv[]); /* Renamed the main function */

// MODIFICATION: Return one file from archive in memory
const char* miniunz_onefile_to_memory(const char* archive, const char* filename);
void miniunz_free(const char *ptr);

#ifdef __cplusplus
}
#endif

#endif /* End of header file MINIUNZ_H */
