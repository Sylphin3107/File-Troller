#ifndef SPAWNROOT_H
#define SPAWNROOT_H

#define POSIX_SPAWN_PERSONA_FLAGS_OVERRIDE 1
extern int posix_spawnattr_set_persona_np(const posix_spawnattr_t* __restrict, uid_t, uint32_t);
extern int posix_spawnattr_set_persona_uid_np(const posix_spawnattr_t* __restrict, uid_t);
extern int posix_spawnattr_set_persona_gid_np(const posix_spawnattr_t* __restrict, uid_t);

int fd_is_valid(int fd);
NSString* getNSStringFromFile(int fd);
int spawnRoot(NSString* path, NSArray* args, NSString** stdOut, NSString** stdErr);

#endif // SPAWNROOT_H
