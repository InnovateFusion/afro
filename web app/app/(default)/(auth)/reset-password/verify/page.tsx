"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useForm } from "react-hook-form";
import { z } from "zod";

import { Button } from "@/components/ui/button";
import {
  Form,
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form";
import {
  InputOTP,
  InputOTPGroup,
  InputOTPSlot,
} from "@/components/ui/input-otp";
import { useFormState } from "react-dom";
import { useFormStatus } from "react-dom";
import { ArrowBigLeft, Loader2 } from "lucide-react";
import { Input } from "@/components/ui/input";
import { redirect, useSearchParams } from "next/navigation";
import resetPasswordAction from "../resetPasswordAction";
import Link from "next/link";

const FormSchema = z
  .object({
    pin: z.string().min(4, {
      message: "Your one-time password must be 4 characters.",
    }),
    email: z.string(),
    password: z.string().min(6, {
      message: "Your password must be at least 6 characters.",
    }),
    confirmPassword: z.string(),
  })
  .superRefine(({ confirmPassword, password }, ctx) => {
    if (confirmPassword !== password) {
      ctx.addIssue({
        code: "custom",
        message: "The passwords did not match",
      });
    }
  });

export default function InputOTPForm() {
  const [errorMessage, dispatch] = useFormState(resetPasswordAction, undefined);
  const searchParams = useSearchParams();
  const email = searchParams.get("email") || "";

  const form = useForm<z.infer<typeof FormSchema>>({
    resolver: zodResolver(FormSchema),
    defaultValues: {
      pin: "",
      email,
      password: "",
      confirmPassword: "",
    },
  });

  return (
    <div className="p-16">
      <div className="mx-auto flex w-full flex-col justify-start space-y-6 sm:w-[350px] p-5">
        <div className="flex flex-col space-y-2 text-center">
          <h1 className="text-2xl font-normal tracking-tight">
            Verify your email
          </h1>
          <p className="text-sm text-muted-foreground">
            We have sent a one-time password to your email address{" "}
            <span className="font-bold">{email}</span>
          </p>
        </div>
        <Form {...form}>
          <form action={dispatch} className="space-y-6">
            <FormField
              control={form.control}
              name="pin"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>One-Time Password</FormLabel>
                  <FormControl>
                    <InputOTP maxLength={4} {...field}>
                      <InputOTPGroup>
                        <InputOTPSlot index={0} />
                        <InputOTPSlot index={1} />
                        <InputOTPSlot index={2} />
                        <InputOTPSlot index={3} />
                      </InputOTPGroup>
                    </InputOTP>
                  </FormControl>
                  <FormDescription>
                    Enter the one-time password sent to your email{" "}
                    <span className="font-bold">{email}</span> and your new
                    password.
                  </FormDescription>
                  <FormMessage />
                </FormItem>
              )}
            />
            <FormField
              control={form.control}
              name="email"
              render={({ field }) => (
                <FormItem>
                  <FormLabel className="sr-only">One-Time Password</FormLabel>
                  <FormControl>
                    <Input className="hidden" maxLength={6} {...field} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            <FormField
              control={form.control}
              name="password"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Password</FormLabel>
                  <FormControl>
                    <Input {...field} type="password" min={6} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            <FormField
              control={form.control}
              name="confirmPassword"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Confirm Password</FormLabel>
                  <FormControl>
                    <Input {...field} type="password" />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            {errorMessage && (
              <p className="text-red-600 dark:text-blue-800">{errorMessage}</p>
            )}
            <VerifyButton />
          </form>
        </Form>
        <p className="text-sm text-muted-foreground flex justify-start gap-2">
          <Link href="/login" className="text-primary hover:underline flex items-center">
            <ArrowBigLeft />
            Back to login
          </Link>
        </p>
      </div>
    </div>
  );
}

function VerifyButton() {
  const { pending } = useFormStatus();

  const handleClick = (event: React.MouseEvent<HTMLButtonElement>) => {
    if (pending) {
      event.preventDefault();
    }
  };

  return (
    <Button
      aria-disabled={pending}
      type="submit"
      onClick={handleClick}
      className="w-full"
    >
      {pending && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
      Submit
    </Button>
  );
}
