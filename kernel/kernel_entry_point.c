void kernel_entry()
{
    const char *LoadingMessage = "Kernel Loading....";
    char *video_memory = (char*) 0xb8000;
    for(int i = 0; LoadingMessage[i] != 0; ++i)
    {
        video_memory[i * 2] = LoadingMessage[i];
        video_memory[i * 2  + 1] = 0x07
    }
    while(1);
}