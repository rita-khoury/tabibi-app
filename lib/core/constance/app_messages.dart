class AppMessages {
  // Waitlist Messages
  static const String waitlistSuccessTitle = "Success";
  static const String waitlistSuccessBody = "Successfully added to the waitlist";
  static const String waitlistLeaveTitle = "Success";
  static const String waitlistLeaveBody = "Successfully left the waitlist";
  static const String waitlistErrorTitle = "Waitlist Error";
  static const String waitlistLeaveErrorTitle = "Error";
  static const String waitlistLeaveErrorBody = "Failed to leave the waitlist";
  static const String defaultWaitlistError = "Failed to join waitlist";

  // Dialog Messages
  static const String dayFullyBookedTitle = "Day Fully Booked";
  static const String dayFullyBookedBody = "Sorry, this day is fully booked. Would you like to join the waitlist?";
  static const String confirmYes = "Yes, add me";
  static const String cancel = "Cancel";

  // Profile Warning Messages
  static const String incompleteProfileTitle = "Incomplete Profile";
  static const String incompleteProfileBody = "Your medical profile is incomplete or missing!\nPlease complete your profile to proceed with booking appointments.";
  static const String skip = "Skip";
  static const String completeProfile = "Complete Profile";

  // General & Network Errors
  static const String errorTitle = "Error";
  static const String noticeTitle = "Notice";
  static const String successTitle = "Success";

  static const String defaultBookingError = "Sorry, unable to complete the booking at this time";
  static const String connectionError = "Server connection error occurred";
  static const String unexpectedError = "An unexpected error occurred";
  static const String appointmentSuccess = "Appointment created successfully";

  // Appointments Status / Error Messages
  static const String appointmentCancelSuccess = "Appointment cancelled successfully";
  static const String appointmentCancelError = "Connection failed";
  static const String appointmentCompleteSuccess = "Appointment completed successfully";
  static const String appointmentCompleteError = "Failed to complete appointment";

  // Queue & Check-in Messages
  static const String queueFetchError = "Failed to fetch current queue status";
  static const String checkInSuccessTitle = "Success";
  static const String checkInSuccessBody = "Checked in successfully";
  static const String serverErrorTitle = "Server Error";
  static const String unknownServerError = "Unknown server error";
  // Profile Completion Messages
  static const String profileSaveSuccessTitle = "Success";
  static const String profileSaveSuccessBody = "Your data has been saved successfully";
  static const String profileSaveErrorTitle = "Error";
  static const String profileSaveErrorBody = "Failed to save data: ";

  // Doctor Profile / Favorite Messages
  static const String favoriteErrorTitle = "Error";
  static const String favoriteUpdateError = "Failed to update favorites list, please try again later";

  // Doctor Ratings Messages
  static const String ratingSuccessTitle = "Success";
  static const String ratingSuccessBody = "Your rating has been added successfully";
  static const String reportSuccessTitle = "Done";
  static const String reportSuccessBody = "Report submitted successfully";
  static const String ratingErrorTitle = "Error";

  // Favorites Messages
  static const String favoritesErrorTitle = "Error";
  static const String removeFavoriteError = "Failed to remove item";
  static const String updateFavoriteError = "An error occurred while updating";

  // Help & Support Messages
  static const String reportTitle = "Report";
  static const String reportFeatureComingSoon = "Feature will be connected to backend soon";
  static const String privacyPolicyTitle = "Privacy Policy";
  static const String privacyPolicyContent = "We respect your privacy. All medical data is securely stored and not shared without consent.";
  static const String aboutAppTitle = "About App";
  static const String aboutAppContent = "Tabibi is a medical app that helps patients manage records and connect with doctors.";

  // Reminders / Referrals Messages
  static const String remindersErrorTitle = "Error";
  static const String fetchReferralsError = "Failed to fetch referrals: ";

  // Home / Auth Messages
  static const String logoutTitle = "Logout";
  static const String logoutSuccess = "Logged out successfully";
  static const String homeErrorTitle = "Error";
  static const String loadDataError = "Failed to load data: ";
  static const String specialitiesErrorTitle = "Error";
  static const String loadSpecialitiesError = "Failed to load specialities";

  // Notifications Messages
  static const String notificationsErrorTitle = "Error";
  static const String fetchNotificationsError = "Failed to fetch notifications: ";
  static const String markReadError = "Failed to mark notification as read: ";
  static const String markAllReadError = "Failed to mark all notifications as read: ";

  // Specialities Messages

  static const String fetchSpecialitiesError = "Failed to fetch specialities: ";


  // Home / Auth Messages
  static const String loginEmptyFieldsError = "Please fill in all fields";
  static const String loginEmptyIdentifierError = "Please enter your email or phone number";
  static const String loginInvalidCredentials = "Invalid login credentials";
  static const String otpSendError = "Failed to send code";

// Medical Record & Profile Messages
  static const String undefinedValue = "Not specified";
  static const String noneValue = "None";
  static const String fetchProfileError = "Failed to fetch medical profile";
  static const String fetchHistoryError = "Failed to fetch medical history";
  static const String fetchMoreHistoryError = "Failed to load more visits";
  static const String uploadAttachmentSuccess = "Attachment uploaded successfully";
  static const String uploadAttachmentError = "Failed to upload attachment";
  static const String deleteAttachmentSuccess = "Attachment deleted successfully";
  static const String deleteAttachmentError = "Failed to delete attachment: ";
  static const String fetchMedicinesError = "Failed to fetch medicines";
  static const String updateProfileSuccess = "Medical profile updated successfully";
  static const String updateProfileError = "Update failed";
}