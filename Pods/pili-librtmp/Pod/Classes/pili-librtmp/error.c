#include "error.h"
#include <stdlib.h>
#include <string.h>

void RTMPError_Alloc(RTMPError *error, size_t msg_size) {
    if (error) {
        RTMPError_Free(error);
        
        error->code = 0;
        error->message = (char *)malloc(msg_size + 1);
        memset(error->message, 0, msg_size);
    }
}

void RTMPError_Free(RTMPError *error) {
    if (error) {
        if (error->message) {
            free(error->message);
            error->message = NULL;
        }
    }
}

void RTMPError_Message(RTMPError *error, int code, const char *message) {
    if (error && message) {
        RTMPError_Alloc(error, strlen(message));
        error->code = code;
        strcpy(error->message, message);
    }
}
